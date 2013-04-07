class AdminsController < ApplicationController
  before_filter :authenticate_admin!
  
  def dashboard
    @admin = current_admin
  end

  def send_announcement
    @admin = current_admin
    Delayed::Job.enqueue AnnouncementJob.new(params[:subject], params[:message], User.find(:all).collect(&:email))
    redirect_to admins_dashboard_path, notice: "Announcement emails have been queued."
  end
end
