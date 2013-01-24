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

end