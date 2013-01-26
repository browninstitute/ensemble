class ParagraphsController < ApplicationController
  def edit
    @p = Paragraph.find(params[:id])
    @story = @p.scene.story
    render 'stories/show'
  end
  
  def create
    @scene = Scene.find(params[:scene_id])
    @p = @scene.paragraphs.build(params[:paragraph])
    @p.user_id = current_user.id
    if @p.save
      redirect_to @p.scene.story
    else
      flash.now[:error] = "Your submitted answer cannot be empty. Please type something and then submit."
      @story = @scene.story
      render 'stories/show'
    end
  end

  def update
    @p = Paragraph.find(params[:id])

    if @p.update_attributes(params[:paragraph])
      redirect_to @p.scene.story, notice: "Paragraph was successfully updated."
    else
      render action: "edit" 
    end
  end

  def destroy
    @p = Paragraph.find(params[:id])
    @p.destroy

    redirect_to @p.scene.story
  end

  # Toggle likes on a paragraph
  def like
    @para = Paragraph.find(params[:id])
    
    if current_user.voted_up_on? @para
      @para.disliked_by current_user
    else
      @para.liked_by current_user
    end

    respond_to do |format|
      format.js
    end
  end
end
