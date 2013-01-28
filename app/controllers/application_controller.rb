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

end
