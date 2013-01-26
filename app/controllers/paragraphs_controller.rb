class ParagraphsController < ApplicationController
  def edit
    @p = Paragraph.find(params[:id])
    @scene = @p.scene
    respond_to do |format|
      format.js
    end
  end
 
  def new
    @p = Paragraph.new
    @scene = Scene.find(params[:scene_id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @scene = Scene.find(params[:scene_id])
    @p = @scene.paragraphs.build(params[:paragraph])
    @p.user_id = current_user.id
    if @p.save
      flash.now[:success] = "Contribution successfully saved."
      respond_to do |format|
        format.js
      end
    else
      flash.now[:error] = "Your submitted answer cannot be empty. Please type something and then submit."
    end
  end

  def update
    @p = Paragraph.find(params[:id])

    if @p.update_attributes(params[:paragraph])
      flash.now[:success] = "Contribution was successfully updated."
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

    redirect_to @p.scene.story, notice: "Contribution was deleted."
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
