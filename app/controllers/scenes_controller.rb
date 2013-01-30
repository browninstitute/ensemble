class ScenesController < ApplicationController
  def edit
    @scene = Scene.find(params[:id])

    respond_to do |format|
      format.js
    end
  end
  
  def update
    @scene = Scene.find(params[:id])

    if @scene.update_attributes(params[:scene])
      flash.now[:success] = "Scene was successfully updated."
      respond_to do |format|
        format.js
      end
    else
      @errormsg = @scene.errors.to_a.each { |e| e.capitalize }.join(". ")
      respond_to do |format|
        format.js { render :action => 'error' }
      end
    end 
  end

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
