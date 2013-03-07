class StoryRolesController < ApplicationController

  def index
    @story = Story.find(params[:story_id])
    @story_role = StoryRole.new
    respond_to do |format|
      format.js
    end
  end

  def show
  end

  def create
    puts params.inspect
    @story_role = StoryRole.new(params[:story_role])
    @story = Story.find(params[:story_id])

    @story_role.story = @story

    authorize! :manage, @story_role
    
    if @story_role.user != nil && @story_role.save
      @story_role = StoryRole.new
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @story_role = StoryRole.find(params[:id])

    authorize! :manage, @story_role
    
    @story_role.destroy

    @story = Story.find(params[:story_id])
    @story_role = StoryRole.new
    respond_to do |format|
      format.js
    end
  end
end
