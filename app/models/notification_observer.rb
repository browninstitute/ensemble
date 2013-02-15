class NotificationObserver < ActiveRecord::Observer
  observe :comment

  def after_create(record)
    commenter = User.find(record.user_id)
    record.scene.commenters.each do |noticee|
      if commenter.id != noticee.id
        NotificationMailer.delay.comment_notification(noticee, commenter)
      end
    end
  end
end
