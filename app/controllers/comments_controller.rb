class CommentsController < ApplicationController

  # Toggle likes on a comment
  def like
    @comment = Comment.find(params[:id])
    
    if current_user.voted_up_on? @comment
      @comment.disliked_by current_user
    else
      @comment.liked_by current_user
    end

    respond_to do |format|
      format.js
    end
  end

  def index
  end

  def show
  end

  def create
  end

  def edit
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.js
      end
    end
  end

  def destroy
  end
end