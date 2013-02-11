module StoriesHelper
  include Rails.application.routes.url_helpers

  # Generates text displaying the published status of a story.
  def published_status(story)
    return if story.updated_at.nil?

    "Last published #{time_ago_in_words(story.updated_at)} ago."
  end

  # Returns the right text for an activity item in the history feed.
  # Passed a record from the Version table.
  def activity_text(activity)
    if activity.whodunnit.nil?
      whodunnit = "COOLGUY"
    else
      whodunnit = User.find(activity.whodunnit).name
    end
    whodunnit = link_to whodunnit, "#", :class => 'activity-user'

    case activity.item_type
    when "Story"
      case activity.event
      when "create"
        "Story was created by #{whodunnit}"
      when "update"
        "Story info was updated by #{whodunnit}"
      when "destroy"
        "Story was deleted by #{whodunnit}"
      end
    when "Scene"
      item = Scene.find(activity.item_id)

      case activity.event
      when "create"
        "#{whodunnit} created scene ##{item.id}"
      when "update"
        "#{whodunnit} edited scene ##{item.id}"
      when "destroy"
        "#{whodunnit} deleted scene ##{item.id}"
      end
    when "Paragraph"
      item = Paragraph.find(activity.item_id)
      scene = item.scene

      case activity.event
      when "create"
        "#{whodunnit} wrote a paragraph for scene ##{scene.id}"
      when "update"
        other = (item.user_id == activity.whodunnit) ? "their" : "#{User.find(item.user_id).name}'s"
        "#{whodunnit} edited #{other} paragraph for the prompt \"#{scene.id}\""
      when "destroy"
        other = (item.user_id == activity.whodunnit) ? "their" : "#{User.find(item.user_id).name}'s"
        "#{whodunnit} deleted #{other} paragraph for the prompt \"#{scene.id}\""
      when "win"
        other = link_to User.find(item.user_id).name, "#"
        "#{whodunnit} crowned the paragraph by #{other} as a winner"
      when "unwin"
        other = link_to User.find(item.user_id).name, "#"
        "#{whodunnit} un-crowned the paragraph by #{other} as a winner"
      when "like"
        other = link_to User.find(item.user_id).name, "#"
        "#{whodunnit} liked the paragraph by #{other}"
      when "unlike"
        other = link_to User.find(item.user_id).name, "#"
        "#{whodunnit} unliked the paragraph by #{other}"
      end
    when "Comment"
      item = Comment.find(activity.item_id)
      scene = item.scene

      case activity.event
      when "create"
        "#{whodunnit} commented on scene ##{scene.id} and said: \"#{truncate(item.content, :length => 10)}\""
      when "update"
        "#{whodunnit} edited their comment on scene ##{scene.id}"
      when "destroy"
        "#{whodunnit} deleted their comment on scene ##{scene.id}"
      end
    end 
  end
end
