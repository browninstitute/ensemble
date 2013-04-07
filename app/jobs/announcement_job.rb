class AnnouncementJob < Struct.new(:subject, :message, :emails)
  def perform
    emails.each { |e| NotificationMailer.announcement_notification(e, subject, message).deliver }
  end
end
