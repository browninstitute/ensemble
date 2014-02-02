class PromptVotesController < ApplicationController
  def create
    @prompt = Prompt.find(params[:prompt_id])
    @story = Story.find(params[:story_id])
    @user = User.find(params[:user_id])
   
    @prompt_vote = PromptVote.new(:prompt_id => @prompt.id, :story_id => @story.id, :user_id => @user.id)
    @prompt_vote.save

    # The number of votes a user has left for this prompt
    @user_vote_count = 3 - PromptVote.where(:prompt_id => @prompt.id, :user_id => current_user.id).count

    respond_to do |format|
      format.js
    end
  end
end
