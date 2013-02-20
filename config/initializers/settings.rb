if Settings.table_exists? && User.table_exists? && !defined?(::Rake)
  # Set setting defaults for users
  User.settings['email.comment_notification'] = true
  User.settings['email.comment_para_notification'] = false
  User.settings['email.like_notification'] = true
  User.settings['email.paragraph_notification'] = true
  User.settings['email.update_paragraph_notification'] = true
  User.settings['email.update_scene_notification'] = true
  User.settings['email.update_scene_para_notification'] = false
end
