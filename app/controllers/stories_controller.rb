require 'format'
require 'arrowhead'

class StoriesController < ApplicationController
  load_and_authorize_resource

  rescue_from ActiveRecord::RecordInvalid, :with => :story_errors

  # GET /stories
  # GET /stories.json
  def index
    @q = Story.search(params[:q])
    @stories = @q.result(:distinct => true).order("created_at DESC").all(:conditions => { :draft => false })

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    @story = Story.find(params[:id])

    # Set meta information
    @page_title = @story.title
    @page_description = @story.subtitle

    if Arrowhead.is_arrowhead_story? @story
      set_meta_tags :og => {
        :title    => @story.title,
        :description => @story.subtitle,
        :type     => 'article',
        :url      => url_for(@story),
        :image    => URI.join(root_url, view_context.image_path('arrowhead_ogimage.jpg'))
      }
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @story.to_json(:include => { :scenes => { :include => :paragraphs }}) }
    end
  end

  # GET /stories/new
  # GET /stories/new.json
  def new
    @story = Story.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @story }
    end
  end

  def cancel_edit
    @story = Story.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # POST /stories
  # POST /stories.json
  def create
    @story = Story.new(params[:story])
    @story.user_id = current_user.id

    if !params[:draft].nil? 
      @story.draft = true
    end
    
    if @story.save && @story.update_contents(params[:story][:content])
      respond_to do |format|
        format.html { redirect_to @story, notice: 'Story was successfully created.' }
        format.js { render :js => "window.location.href = ('#{story_path(@story)}');"}
        format.json { render json: @story, status: :created, location: @story }
      end
    else
      @errormsg = @story.errors.to_a.each { |e| e.capitalize }.join(". ")
      story_errors(@errormsg)
    end
  end

  # PUT /stories/1
  # PUT /stories/1.json
  def update
    @story = Story.find(params[:id])
   
    # If the user publishes it, mark the story as published
    if params[:draft].nil?
      @story.draft = false
    end

    if @story.update_attributes(params[:story]) && @story.update_contents(params[:story][:content])
      respond_to do |format|
        format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        format.js { render :js => "window.location.href = ('#{story_path(@story)}');"}
        format.json { head :no_content }
      end
    else
      @errormsg = @story.errors.to_a.each { |e| e.capitalize }.join(". ")
      story_errors(@errormsg)
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to stories_url }
      format.json { head :no_content }
    end
  end

  # Shows the current story being worked on by the community.
  # TODO: Right now this defaults to the first story in the DB.
  def current
    @story = Story.find(:first)
    if @story.nil?
      render 'no_current_story'
      return
    end

    respond_to do |format|
      format.html { render action: "show" } # show.html.erb
      format.json { render json: @story }
    end
  end

  # Allows the user to preview the story draft.
  # Creates a temporary Story object based on the existing one
  # to create a preview version.
  def preview
    @story = Story.find(params[:id])
    @story.assign_attributes(params[:story])
  end

  # Allows the user to view story history.
  def history
    @story = Story.find(params[:id])
    @versions = @story.activity
  end

  # Allows the user to view different versions of a
  # story.
  def view_version
    @version = params[:version].to_i
    @story = Story.find(params[:id])
    @story = @story.versions[@version].reify

    respond_to do |format|
      format.html { render :version }
      format.html { head :no_content }
    end
  end

  # Show story saving errors.
  def story_errors(errors)
    respond_to do |format| 
      @errormsg = errors || "Something went wrong. Please check to see if any paragraphs are blank."
      format.js { render :action => "error" }
    end
  end

  # Preview the story before submitting it to the story slam
  def preview_submit
    @story = Story.find(params[:submission])
    @story_slam_preview = true # to hide/show certain things in the header
  end

  # Submit story to the contest.
  def storyslam_submit
    @story = Story.find(params[:id]) 
    @submission = Submission.new(:title => @story.title,
                                 :subtitle => @story.subtitle,
                                 :genre1 => @story.genre1,
                                 :genre2 => @story.genre2,
                                 :content => @story.final_draft.map(&:content).join("\n\n"),
                                 :user_id => current_user.id,
                                 :story_id => @story.id)
    @submission.save
    render :layout => "application"
  end
end
