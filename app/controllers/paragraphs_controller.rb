class ParagraphsController < ApplicationController
  def create
    @scene = Scene.find(params[:scene_id])
    @p = @scene.paragraphs.build(params[:paragraph])
    if @p.save
      redirect_to @p.scene.story
    end
  end
end
