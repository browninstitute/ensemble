class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :flash_to_headers

  helper_method :current_or_guest_user

  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
        logging_in
        guest_user.destroy
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # Find guest_user object associated with the current session,
  # or create one if needed.
  def guest_user
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user
  end

  # Called once when the user logs in. 
  # Pass over anything from guest_user to current_user
  def logging_in
  end

  def create_guest_user
    u = User.create(:name => "guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@example.com")
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end

  def current_ability
    @current_ability ||= Ability.new(current_or_guest_user)
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    if user_signed_in?
      session[:user_return_to] = nil
      redirect_to root_url, :alert => exception.message
    else            
      session[:user_return_to] = request.url
      redirect_to new_user_session_url, :alert => "You must first login or register to do that action."
    end 
  end

  def after_sign_in_path_for(resource_or_scope)
    if request.env['omniauth.origin'] && request.env['omniauth.origin'] != new_user_session_url
      request.env['omniauth.origin']
    else
      user_path(current_user)
    end
  end

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
    story_id = (request.parameters[:controller] == "stories") ? request.parameters[:id] : request.parameters[:story_id] 
    scene_id = (request.parameters[:controller] == "scenes") ? request.parameters[:id] : request.parameters[:scene_id]
    
    if (story_id.nil? && !scene_id.nil?)
      story_id = Scene.find(scene_id).story_id
    end
    
    { :story_id => story_id, :scene_id => scene_id }
  end

  # For authenticating admins only.
  def authenticate_adminuser!
    if current_user && current_user.admin?
      authenticate_user!
    else
      raise "Only admins are allowed to access the admin dashboard."
    end
  end
end
