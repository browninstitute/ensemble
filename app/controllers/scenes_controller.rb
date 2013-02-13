class ScenesController < ApplicationController
  load_and_authorize_resource
  
  def new
    @scene = Scene.new(:temp_id => params[:temp_id])
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit
    @scene = Scene.find(params[:id])

    respond_to do |format|
      format.js
    end
  end
  
  def update
    @scene = Scene.find(params[:id])

    if @scene.update_attributes(params[:scene])
      flash.now[:success] = "Scene was successfully updated."
      respond_to do |format|
        format.js
      end
    else
      @errormsg = @scene.errors.to_a.each { |e| e.capitalize }.join(". ")
      respond_to do |format|
        format.js { render :action => 'error' }
      end
    end 
  end

  def destroy
    @scene = Scene.find(params[:id])
    @scene.title = ""
    @scene.content = ""

    if @scene.save
      @scene.comments.destroy_all
      flash.now[:success] = "Scene was successfully deleted."
      respond_to do |format|
        format.js
      end
    end
  end
end
