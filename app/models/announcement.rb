# Announcement Class
# Represents site-wide emails sent to users.

class Announcement < ActiveRecord::Base
  serialize :email, Array # [{:email => "test@test.com", :success => true}, ...]
  attr_accessible :email, :message, :subject
  validates :message, :subject, :presence => true

  # Send the message to all users.
  def deliver
    Delayed::Job.enqueue AnnouncementJob.new(self, self.subject, self.message, User.find(:all).collect(&:email))  
  end

  # True if the announcement was delivered to anyone.
  # Set strict to true to check if the announcement was delivered to everyone.
  def delivered? (strict = false)
    if strict
      self.sent && (self.success_emails.length == User.all.length)
    else
      self.sent && (self.success_emails.length > 0)
    end
  end

  # Returns an array of emails this Announcement got sent to
  def success_emails
    email.select {|e| e[:success] }
  end

  # Returns an array of emails this Announcement did not get sent to.
  def failed_emails
    email.select {|e| !e[:success] }
  end
end
