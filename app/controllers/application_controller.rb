class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :flash_to_headers

  # For showing flash messages after ajax.
  def flash_to_headers
    return unless request.xhr?
    if !flash[:error].blank?
      response.headers['X-Message'] = flash[:error]
      response.headers['X-Message-Type'] = "error"
    elsif !flash[:success].blank?
      response.headers['X-Message'] = flash[:success]
      response.headers['X-Message-Type'] = "success"
    elsif !flash[:notice].blank?
      response.headers['X-Message'] = flash[:notice]
      response.headers['X-Message-Type'] = "info" # info instead of notice for bootstrap growl
    end
    flash.discard
  end

  # For creating error messages on object save/create.
  def error_msgs(obj)
    obj.errors.to_a.each { |e| e.capitalize }.join(". ")
  end

  # For adding extra metadata to paper_trail version tracking.
  def info_for_paper_trail
    story_id = request.parameters[:story_id]
    scene_id = request.parameters[:scene_id]
    
    if (story_id.nil? && !scene_id.nil?)
      story_id = Scene.find(scene_id).story_id
    end
    
    { :story_id => story_id, :scene_id => scene_id }
  end
end
