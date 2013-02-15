class NotificationMailer < ActionMailer::Base
  default from: "ensemble@cs.stanford.edu"

  # Sends you an email when a user comments on a scene
  # you commented on.
  def comment_notification(user, other, comment)
    @user = user
    @other = other
    @comment = comment
    mail(:to => user.email, :subject => "#{other.name} replied to your comment on Ensemble")
  end

  # Sends you an email when a user comments on a scene you
  # contributed to.
  def comment_para_notification(user, other, comment)
    @user = user
    @other = other
    @comment = comment
    mail(:to => user.email, :subject => "#{other.name} commented on a scene you wrote for on Ensemble")
  end

  # Sends you an email when a user contributes to a scene
  # you commented on or contributed to.
  def paragraph_notification(user, other, paragraph)
    @user = user
    @other = other
    @para = paragraph
    mail(:to => user.email, :subject => "#{other.name} wrote for a scene you commented on at Ensemble")
  end

  # Sends you an email when another user edits a paragraph
  # that you wrote.
  def update_paragraph_notification(user, other, paragraph)
    @user = user
    @other = other
    @para = paragraph
    mail(:to => user.email, :subject => "#{other.name} made edits to a paragraph you wrote on Ensemble")
  end

  # Sends you an email when a user updates a scene
  # that you commented on.
  def update_scene_notification(user, other, scene)
    @user = user
    @other = other
    @scene = scene
    mail(:to => user.email, :subject => "#{other.name} made edits to a scene you commented on at Ensemble")
  end

  # Sends you an email when a user updates a scene
  # that you contributed to.
  def update_scene_para_notification(user, other, scene)
    @user = user
    @other = other
    @scene = scene
    mail(:to => user.email, :subject => "#{other.name} made edits to a scene you wrote a paragraph for on Ensemble")
  end

  # Sends you an email when a user likes a paragraph you
  # wrote.
  def like_notification(user, other, paragraph)
    @user = user
    @other = other
    @para = paragraph
    mail(:to => user.email, :subject => "#{other.name} liked your paragraph on Ensemble")
  end
end
