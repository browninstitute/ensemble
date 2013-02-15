class NotificationMailer < ActionMailer::Base
  default from: "ensemble@cs.stanford.edu"

  # Sends you an email when a user comments on a scene
  # you commented on or contributed to.
  def comment_notification(user, other)
    mail(:to => user.email, :subject => "#{other.name} replied to your comment on Ensemble")
  end

  # Sends you an email when a user contributes to a scene
  # you commented on or contributed to.
  def paragraph_notification
  end

  # Sends you an email when a user likes a paragraph you
  # wrote.
  def like_notification
  
  end
end
