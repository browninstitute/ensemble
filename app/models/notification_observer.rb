class NotificationObserver < ActiveRecord::Observer
  observe :post, :story_role, :story_flag, :comment, :paragraph, :version

  def after_create(record)
    if record.is_a? StoryRole
      mod = User.find(record.story.user_id)
      contributor = User.find(record.user_id)
      if contributor.settings['email.added_as_contributor']
        NotificationMailer.delay.added_as_contributor_notification(mod, contributor, record)
      end
    elsif record.is_a? Post
      story = record.story
      poster = User.find(record.user_id)
      noticees = (story.moderators + story.contributors).push(story.user)
      
      noticees.each do |noticee|
        if poster.id != noticee.id && noticee.settings['email.forum_notification']
          NotificationMailer.delay.forum_notification(noticee, poster, record)
        end
      end
    elsif record.is_a? StoryFlag
      story = Story.find(record.story_id)
      user = story.user
      reason = record.reason
      if user.settings['email.mod.story_flagged']
        NotificationMailer.delay.mod_story_flagged(story, reason)
      end
    elsif record.is_a? Comment
      commenter = record.user_id.nil? ? nil : User.find(record.user_id)
     
      if !record.scene.nil? # handle scene comments only
        if !record.scene.nil? && !record.scene.story.nil?
          mod = User.find(record.scene.story.user_id)
          if (commenter.nil? || mod.id != commenter.id) && mod.settings['email.mod.comment_notification']
            NotificationMailer.delay.mod_comment_notification(mod, commenter, record)
            mod_comment_notification_sent = true
          end
        end

        record.scene.commenters.each do |noticee|
          if !(noticee.id == mod.id && mod_comment_notification_sent) && (commenter.nil? || commenter.id != noticee.id) && noticee.settings['email.comment_notification']
            NotificationMailer.delay.comment_notification(noticee, commenter, record)
          end
        end
          
        record.scene.contributors.each do |noticee|
          if (commenter.nil? || commenter.id != noticee.id) && noticee.settings['email.comment_para_notification']
            NotificationMailer.delay.comment_para_notification(noticee, commenter, record)
          end
        end
      end
    elsif record.is_a? Paragraph
      contributor = record.user_id.nil? ? nil : User.find(record.user_id)

      if !record.scene.nil? && !record.scene.story.nil?
        mod = User.find(record.scene.story.user_id)
        if (contributor.nil? || mod.id != contributor.id) && mod.settings['email.mod.paragraph_notification']
          NotificationMailer.delay.mod_paragraph_notification(mod, contributor, record)
          mod_para_notification_sent = true
        end
      end
      
      record.scene.commenters.each do |noticee|
        if !(noticee.id == mod.id && mod_para_notification_sent) && (contributor.nil? || contributor.id != noticee.id) && noticee.settings['email.paragraph_notification']
          NotificationMailer.delay.paragraph_notification(noticee, contributor, record)
        end
      end
    elsif record.is_a? Version
      # using this as a proxy for detecting likes and updates
      if record.item_type == "Paragraph" && record.event == "like"
        voter = User.find(record.whodunnit)
        paragraph = Paragraph.find(record.item_id)
        noticee = User.find(paragraph.user_id)
        
        if !paragraph.scene.nil? && !paragraph.scene.story.nil?
          mod = User.find(paragraph.scene.story.user_id)
          if mod.id != voter.id && mod.settings['email.mod.like_notification']
            NotificationMailer.delay.mod_like_notification(mod, voter, paragraph)
            mod_like_notification_sent = true
          end
        end
        
        if !(noticee.id == mod.id && mod_like_notification_sent) && voter.id != noticee.id && noticee.settings['email.like_notification']
          NotificationMailer.delay.like_notification(noticee, voter, paragraph)
        end
      elsif record.item_type == "Paragraph" && record.event == "win"
        marker = User.find(record.whodunnit)
        paragraph = Paragraph.find(record.item_id)
        noticee = User.find(paragraph.user_id)

        if !paragraph.scene.nil? && !paragraph.scene.story.nil?
          mod = User.find(paragraph.scene.story.user_id)
          if mod.id != marker.id && mod.settings['email.mod.winner_notification']
            NotificationMailer.delay.mod_winner_notification(mod, marker, paragraph)
            mod_winner_notification_sent = true
          end
        end

        if !(noticee.id == mod.id && mod_winner_notification_sent) && marker.id != noticee.id && noticee.settings['email.winner_notification']
          NotificationMailer.delay.winner_notification(noticee, paragraph)
        end
      elsif record.item_type == "Paragraph" && record.event == "update"
        editor = User.find(record.whodunnit)
        paragraph = Paragraph.find(record.item_id)
        noticee = User.find(paragraph.user_id)
        
        if !paragraph.scene.nil? && !paragraph.scene.story.nil?
          mod = User.find(paragraph.scene.story.user_id)
          if mod.id != editor.id && mod.settings['email.mod.update_paragraph_notification']
            NotificationMailer.delay.mod_update_paragraph_notification(mod, editor, paragraph)
            mod_update_para_notification_sent = true
          end
        end
        
        if !(noticee.id == mod.id && mod_update_para_notification_sent) && editor.id != noticee.id && noticee.settings['email.update_paragraph_notification']
          NotificationMailer.delay.update_paragraph_notification(noticee, editor, paragraph)
        end
      elsif record.item_type == "Scene" && record.event == "update"
        editor = User.find(record.whodunnit)
        scene = Scene.find(record.item_id)

        scene.commenters.each do |noticee|
          if editor.id != noticee.id && noticee.settings['email.update_scene_notification']
            NotificationMailer.delay.update_scene_notification(noticee, editor, scene)
          end
        end
      
        scene.contributors.each do |noticee|
          if editor.id != noticee.id && noticee.settings['email.update_scene_para_notification']
            NotificationMailer.delay.update_scene_para_notification(noticee, editor, scene)
          end
        end
      end
    end
  end
end
