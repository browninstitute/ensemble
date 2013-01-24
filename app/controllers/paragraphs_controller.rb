class ParagraphsController < ApplicationController
  def create
    @scene = Scene.find(params[:scene_id])
    @p = @scene.paragraphs.build(params[:paragraph])
    if @p.save
      redirect_to @p.scene.story
    else
      flash[:error] = "Your submitted answer cannot be empty. Please type something and then submit."
      @story = @scene.story
      render 'stories/show'
    end
  end
end
