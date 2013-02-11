require 'format'

class StoriesController < ApplicationController
  load_and_authorize_resource

  rescue_from ActiveRecord::RecordInvalid, :with => :story_errors

  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    @story = Story.find(params[:id])

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
      format.js
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
end
