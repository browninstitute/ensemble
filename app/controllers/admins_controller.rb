class AdminsController < ApplicationController
  before_filter :authenticate_adminuser!
 
  def dashboard
    @admin = current_admin
    @announcement = Announcement.new
  end

  def send_announcement
    @admin = current_admin
    @announcement = Announcement.new(params[:announcement])

    if @announcement.save
      @announcement.deliver
      redirect_to admins_dashboard_path, notice: "Announcement emails have been queued."
    end
  end
end
