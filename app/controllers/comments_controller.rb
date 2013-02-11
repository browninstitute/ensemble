class CommentsController < ApplicationController
  load_and_authorize_resource
  
  def index
  end

  def show
  end

  def new
    @scene = Scene.find(params[:scene_id])
    @comment = @scene.comments.new

    respond_to do |format|
      format.js
    end
  end

  def create
    @scene = Scene.find(params[:scene_id])
    @comment = @scene.comments.new(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.js
      else
        @errormsg = error_msgs(@comment)
        format.js { render :action => "error" }
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @comment = Comment.find(params[:id])
    authorize! :update, @comment

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.js
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
        format.js
      end
    end
  end
end
