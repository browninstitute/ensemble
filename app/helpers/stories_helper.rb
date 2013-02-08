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
        "Story title was updated by #{whodunnit}"
      when "destroy"
        "Story was deleted by #{whodunnit}"
      end
    when "Scene"
      item = Scene.find(activity.item_id)

      case activity.event
      when "create"
        "#{whodunnit} created a new prompt: \"#{item.title}\""
      when "update"
        "#{whodunnit} edited the prompt: \"#{item.title}\""
      when "destroy"
        "#{whodunnit} deleted the prompt: \"#{item.title}\""
      end
    when "Paragraph"
      item = Paragraph.find(activity.item_id)
      scene = item.scene

      case activity.event
      when "create"
        "#{whodunnit} added a suggestion to the prompt: \"#{scene.title}\""
      when "update"
        "#{whodunnit} edited their suggestion for the prompt \"#{scene.title}\""
      when "destroy"
        "#{whodunnit} deleted their suggestion for the prompt \"#{scene.title}\""
      when "win"
        other = link_to User.find(item.user_id).name, "#"
        "#{whodunnit} crowned the suggestion by #{other} as a winner"
      when "unwin"
        other = link_to User.find(item.user_id).name, "#"
        "#{whodunnit} un-crowned the suggestion by #{other} as a winner"
      when "like"
        other = link_to User.find(item.user_id).name, "#"
        "#{whodunnit} liked the suggestion by #{other}"
      when "unlike"
        other = link_to User.find(item.user_id).name, "#"
        "#{whodunnit} unliked the suggestion by #{other}"
      end
    when "Comment"
      item = Comment.find(activity.item_id)
      scene = item.scene

      case activity.event
      when "create"
        "#{whodunnit} commented on the prompt: \"#{scene.title}\" and said: \"#{truncate(item.content, :length => 10)}\""
      when "update"
        "#{whodunnit} edited their comment on the prompt: \"#{scene.title}\""
      when "destroy"
        "#{whodunnit} deleted their comment on the prompt: \"#{scene.title}\""
      end
    end 
  end
end
