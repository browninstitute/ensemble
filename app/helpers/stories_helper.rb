module StoriesHelper
  include Rails.application.routes.url_helpers

  # Renders the example new story
  def render_new_story_example
    new_story_scenes = Array.new
    new_story_scenes[0] = Scene.new(:title => "Setting the stage",
                                    :content => "How should the characters and the setting be introduced?",
                                    :position => 1)
    new_story_scenes[1] = Scene.new(:title => "The big event", 
                                    :content => "I need suggestions on the big event that changes the characters' lives and puts the story into motion.", 
                                    :position => 2)
    new_story_scenes[2] = Scene.new(:position => 3)
    new_story_scenes[3] = Scene.new(:position => 4)
    new_story_scenes[4] = Scene.new(:position => 5)
   
    html = ""
    new_story_scenes.each do |s|
      html += render :partial => "scenes/scene", :locals => {:scene => s, :edit_mode => true}
    end
    html.html_safe
  end

  def new_story_example_text(position)
    case position
    when 1
      "Once upon a time..."
    when 2
      "One day..."
    when 3
      "So they..."
    when 4
      "Finally, they..."
    when 5
      "And they lived happily ever after."
    end
  end

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
      item = Scene.find_by_id(activity.item_id)

      case activity.event
      when "create"
        "#{whodunnit} created scene ##{activity.item_id}"
      when "update"
        "#{whodunnit} edited scene ##{activity.item_id}"
      when "destroy"
        "#{whodunnit} deleted scene ##{activity.item_id}"
      end
    when "Paragraph"
      if !Paragraph.exists? activity.item_id
        return
      end
      item = Paragraph.find(activity.item_id)
      scene = item.scene

      case activity.event
      when "create"
        "#{whodunnit} wrote a paragraph for scene ##{scene.id}"
      when "update"
        other = (item.user_id.to_i == activity.whodunnit.to_i) ? "their" : "#{User.find(item.user_id).name}'s"
        "#{whodunnit} edited #{other} paragraph for scene ##{scene.id}"
      when "destroy"
        other = (item.user_id.to_i == activity.whodunnit.to_i) ? "their" : "#{User.find(item.user_id).name}'s"
        "#{whodunnit} deleted #{other} paragraph for scene ##{scene.id}"
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
      if !Comment.exists? activity.item_id
        return
      end
      item = Comment.find(activity.item_id)
      
      case activity.event
      when "create"
        "#{whodunnit} commented on scene ##{item.scene_id} and said: \"#{truncate(item.content, :length => 10)}\""
      when "update"
        "#{whodunnit} edited their comment on scene ##{item.scene_id}"
      when "destroy"
        "#{whodunnit} deleted their comment on scene ##{item.scene_id}"
      end
    end 
  end
end
