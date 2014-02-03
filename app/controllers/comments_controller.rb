class CommentsController < ApplicationController
  load_and_authorize_resource
  impressionist

  def index
  end

  def show
  end

  def new
    if params[:scene_id].nil?
      @story = Story.find(params[:story_id])
      @comment = @story.comments.new
    else
      @scene = Scene.find(params[:scene_id])
      @comment = @scene.comments.new
    end

    respond_to do |format|
      format.js
    end
  end

  def create
    if params[:scene_id].nil?
      @story = Story.find(params[:story_id])
      @comment = @story.comments.new(params[:comment])
      @comment.user = current_user
    else
      @scene = Scene.find(params[:scene_id])
      @comment = @scene.comments.new(params[:comment])
      @comment.scene_id = @scene.id
      @comment.user = current_or_guest_user.nil? ? nil : current_user
    end

    respond_to do |format|
      if @comment.save
        if params[:scene_id].nil?
          format.js { render :action => "story_create" }
        else
          format.js
        end
      else
        @errormsg = error_msgs(@comment)
        format.js { render :action => "error" }
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.scene.nil?
        format.js { render :action => "story_edit" }
      else
        format.js
      end
    end
  end

  def update
    @comment = Comment.find(params[:id])
    authorize! :update, @comment

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        if @comment.scene.nil?
          format.js { render :action => "story_update" }
        else
          format.js
        end
      else 
        @errormsg = error_msgs(@comment)
        format.js { render :action => "error" }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.destroy
        if @comment.scene.nil?
          format.js { render :action => "story_destroy" }
        else
          format.js
        end
      end
    end
  end
end
