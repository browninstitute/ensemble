class StoriesController < ApplicationController
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
      format.json { render json: @story }
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
  end

  # POST /stories
  # POST /stories.json
  def create
    @story = Story.new(params[:story])
    @story.user_id = current_user.id

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: 'Story was successfully created.' }
        format.json { render json: @story, status: :created, location: @story }
      else
        format.html { render action: "new" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stories/1
  # PUT /stories/1.json
  def update
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
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
  def current_story
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

  # Saves a draft of the story.
  def save_draft
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.save_draft(params[:story][:story_text])
        flash[:notice] = "Draft successfully saved."
        format.html { redirect_to :action => "edit" }
        format.json { head :no_content }
      else
        format.html { redirect_to :action => "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # Discards the current story draft, if there is one.
  def destroy_draft
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.destroy_draft
        flash[:notice] = "Draft successfully discarded."
        format.html { redirect_to :action => "edit" }
        format.json { head :no_content }
      else
        format.html { redirect_to :action => "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # Allows the user to preview the story draft.
  def preview
    @story = Story.find(params[:id])
  
    respond_to do |format|
      if @story.save_draft(params[:story][:story_text])
        format.html { redirect_to story_path(@story, :preview => true) }
        format.json { head :no_content }
      else
        format.html { redirect_to :action => "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end
end
