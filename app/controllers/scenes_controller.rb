class ScenesController < ApplicationController

  # Toggle likes on a scene
  def like
    @scene = Scene.find(params[:id])
    
    if current_user.voted_up_on? @scene
      @scene.disliked_by current_user
    else
      @scene.liked_by current_user
    end

    respond_to do |format|
      format.js
    end
  end

  def new_comment
    @scene = Scene.find(params[:id])
    @comment = @scene.comments.new

    respond_to do |format|
      format.js
    end
  end

  def create_comment
    @scene = Scene.find(params[:id])
    @comment = @scene.comments.new(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.js
      end
    end
  end

end