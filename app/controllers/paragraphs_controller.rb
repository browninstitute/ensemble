class ParagraphsController < ApplicationController
  def edit
    @p = Paragraph.find(params[:id])
    @scene = @p.scene
    respond_to do |format|
      format.js
    end
  end
  
  def create
    @scene = Scene.find(params[:scene_id])
    @p = @scene.paragraphs.build(params[:paragraph])
    @p.user_id = current_user.id
    if @p.save
      respond_to do |format|
        format.js
      end
      
      #redirect_to @p.scene.story
    else
      flash.now[:error] = "Your submitted answer cannot be empty. Please type something and then submit."
      @story = @scene.story
      render 'stories/show'
    end
  end

  def update
    @p = Paragraph.find(params[:id])

    if @p.update_attributes(params[:paragraph])
      #redirect_to @p.scene.story, notice: "Paragraph was successfully updated."
      respond_to do |format|
        format.js
      end
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

  def winner
    @p = Paragraph.find(params[:id])
    
    if @p.is_winner?
      @p.unset_as_winner
    else
      @p.set_as_winner
    end
    
    respond_to do |format|
      format.js
    end
  end
end
