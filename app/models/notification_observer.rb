class NotificationObserver < ActiveRecord::Observer
  observe :comment

  def after_create(record)
    if record.is_a? Comment
      commenter = User.find(record.user_id)
      record.scene.commenters.each do |noticee|
        if commenter.id != noticee.id
          NotificationMailer.delay.comment_notification(noticee, commenter, record)
        end
      end
    end
  end
end
