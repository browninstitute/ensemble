class NotificationObserver < ActiveRecord::Observer
  observe :comment, :paragraph, :version

  def after_create(record)
    if record.is_a? Comment
      commenter = User.find(record.user_id)
      
      record.scene.commenters.each do |noticee|
        if commenter.id != noticee.id
          NotificationMailer.delay.comment_notification(noticee, commenter, record)
        end
      end
      
      record.scene.contributors.each do |noticee|
        if commenter.id != noticee.id
          NotificationMailer.delay.comment_para_notification(noticee, commenter, record)
        end
      end
    elsif record.is_a? Paragraph
      contributor = User.find(record.user_id)

      record.scene.commenters.each do |noticee|
        if contributor.id != noticee.id
          NotificationMailer.delay.paragraph_notification(noticee, contributor, record)
        end
      end
    elsif record.is_a? Version
      # using this as a proxy for detecting likes and updates
      if record.item_type == "Paragraph" && record.event == "like"
        voter = User.find(record.whodunnit)
        paragraph = Paragraph.find(record.item_id)
        noticee = User.find(paragraph.user_id)
        if voter.id != noticee.id 
          NotificationMailer.delay.like_notification(noticee, voter, paragraph)
        end
      elsif record.item_type == "Paragraph" && record.event == "update"
        editor = User.find(record.whodunnit)
        paragraph = Paragraph.find(record.item_id)
        noticee = User.find(paragraph.user_id)
        if editor.id != noticee.id
          NotificationMailer.delay.update_paragraph_notification(noticee, editor, paragraph)
        end
      elsif record.item_type == "Scene" && record.event == "update"
        editor = User.find(record.whodunnit)
        scene = Scene.find(record.item_id)

        scene.commenters.each do |noticee|
          if editor.id != noticee.id
            NotificationMailer.delay.update_scene_notification(noticee, editor, scene)
          end
        end
      
        scene.contributors.each do |noticee|
          if editor.id != noticee.id
            NotificationMailer.delay.update_scene_para_notification(noticee, editor, scene)
          end
        end
      end
    end
  end
end
