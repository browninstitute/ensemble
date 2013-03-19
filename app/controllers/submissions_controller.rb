class SubmissionsController < ApplicationController
  layout "stories"

  def show
    @story = Submission.find(params[:id])
    @no_story_bar = true
  end

  def destroy
    @story = Submission.find(params[:id])
    if @story.destroy
      respond_to do |format|
        format.js
      end
    end
  end
end
