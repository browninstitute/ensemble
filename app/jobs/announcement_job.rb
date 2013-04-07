class AnnouncementJob < Struct.new(:announcement, :subject, :message, :emails)
  def perform
    emails.each do |e| 
      # First, check if email has been attempted already.
      check_exists = announcement.email.find {|ae| ae[:email] == e}
      
      # If email as been attempted successfully, do nothing.
      if !(check_exists && check_exists[:success]) 
        
        # If attempted but failed, remove record and try again.
        if (check_exists && !check_exists[:success]) 
          announcement.email.reject! {|ae| ae[:email] == e}
          announcement.save
        end
      
        # If not there at all, just try.
        begin
          NotificationMailer.announcement_notification(e, subject, message).deliver 
          announcement.email.push({:email => e, :success => true})
          announcement.save
        rescue => e
          announcement.email.push({:email => e, :success => false})
          announcement.save
        end
      end
    end
  end

  def success(job)
    announcement.sent = true
    announcement.save
  end
end
