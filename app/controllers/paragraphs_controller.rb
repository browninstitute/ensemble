class ParagraphsController < ApplicationController
  load_and_authorize_resource
  impressionist

  def edit
    @p = Paragraph.find(params[:id])
    @scene = @p.scene
    respond_to do |format|
      format.js
    end
  end
 
  def new
    @scene = Scene.find(params[:scene_id])
    @p = @scene.paragraphs.new
    
    if current_or_guest_user.is_guest? && !@p.scene.story.nil? && @p.scene.story.privacy != Story::Privacy::OPEN
      raise CanCan::AccessDenied.new("You must first login or register to do that action.", :create, @p)
      return
    end
    
    respond_to do |format|
      format.js
    end
  end

  def create
    @scene = Scene.find(params[:scene_id])
    @p = @scene.paragraphs.build(params[:paragraph])
    @p.user_id = current_or_guest_user.is_guest? ? nil : current_user.id
    
    # True if looking at scene view
    @sceneview = URI.parse(request.env["HTTP_REFERER"]).path == scene_path(@scene)

    if @p.save
      flash.now[:success] = t('paragraphs.create.notice')
      respond_to do |format|
        format.js
      end
    else
      @errormsg = error_msgs(@p)
      respond_to do |format|
        format.js { render :action => 'error' }
      end
    end
  end

  def update
    @scene = Scene.find(params[:scene_id])
    @p = Paragraph.find(params[:id])

    if @p.update_attributes(params[:paragraph])
      flash.now[:success] = t('paragraphs.update.notice')
      respond_to do |format|
        format.js
      end
    else
      @errormsg = error_msgs(@p)
      respond_to do |format|
        format.js { render :action => 'error' }
      end
    end
  end

  def destroy
    @p = Paragraph.find(params[:id])
    @scene = @p.scene

    # True if looking at scene view
    @sceneview = URI.parse(request.env["HTTP_REFERER"]).path == scene_path(@scene)

    if @p.destroy
      flash.now[:notice] = t("paragraphs.destroy.notice")
      
      @scene.destroy if @scene.paragraphs.length == 0

      respond_to do |format|
        format.js
      end
    end
  end

  # Like a paragraph
  def like
    @para = Paragraph.find(params[:id])
    
    if !current_user.voted_up_on? @para
      @para.liked_by current_user
    end
    Version.create!({:item_type => "Paragraph",
                    :item_id => @para.id,
                    :event => "like",
                    :whodunnit => current_user.id,
                    :scene_id => @para.scene.id,
                    :story_id => @para.scene.story.id})
    @para.touch

    respond_to do |format|
      format.js
    end
  end

  # Unlike a paragraph
  def unlike
    @para = Paragraph.find(params[:id])
    
    if current_user.voted_up_on? @para
      @para.disliked_by current_user
    end
    Version.create!({:item_type => "Paragraph",
                     :item_id => @para.id,
                     :event => "unlike",
                     :whodunnit => current_user.id,
                     :scene_id => @para.scene.id,
                     :story_id => @para.scene.story.id})
    @para.touch
    
    respond_to do |format|
      format.js { render :action =>  "like" }
    end
  end
  
  # Grant winner status of a paragraph
  def winner
    @p = Paragraph.find(params[:id])
    if !@p.is_winner?
      @p.set_as_winner
    end
    Version.create!({:item_type => "Paragraph",
                    :item_id => @p.id,
                    :event => "win",
                    :whodunnit => current_user.id,
                    :scene_id => @p.scene.id,
                    :story_id => @p.scene.story.id})
    
    respond_to do |format|
      format.js
    end
  end

  # Unmark a paragraph as winner
  def unwinner
    @p = Paragraph.find(params[:id])
    if @p.is_winner?
      @p.unset_as_winner
    end
    Version.create!({:item_type => "Paragraph",
                     :item_id => @p.id,
                     :event => "unwin",
                     :whodunnit => current_user.id,
                     :scene_id => @p.scene.id,
                     :story_id => @p.scene.story.id})
  
    respond_to do |format|
      format.js { render :action => "winner" }
    end
  end
end
