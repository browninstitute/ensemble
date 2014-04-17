module StoriesHelper
  include Rails.application.routes.url_helpers

  # Renders the privacy setting selection dropdown
  def privacy_select_dropdown(selected_level = nil)
    html = "<select name='story[privacy]'>"
    Story::Privacy.each do |name, value|
      html += "<option value='#{value}'"
      html += " selected='selected'" if selected_level == value
      html += ">"
      html += privacy_description(value)
      html += "</option>"
    end
    html += "</select>"
    html.html_safe
  end

  def privacy_description(value)
    case value
    when Story::Privacy::PUBLIC
      t 'stories.new.form.privacy_public'
    when Story::Privacy::CONTRIBUTORS
      t 'stories.new.form.privacy_contributors'
    when Story::Privacy::OPEN
      t 'stories.new.form.privacy_guests'
    end
  end

  # Prints out the genres of a story
  def print_genres(story)
    if !story.genre1.nil? && !story.genre2.nil?
      "#{Genre.find(story.genre1).name}/#{Genre.find(story.genre2).name}"
    elsif !story.genre1.nil?
      Genre.find(story.genre1).name
    elsif !story.genre2.nil?
      Genre.find(story.genre2).name
    else
      nil
    end
  end

  # Renders the example new story
  def render_new_story_example
    new_story_scenes = Array.new
    new_story_scenes[0] = Scene.new(:position => 1)
    new_story_scenes[1] = Scene.new(:position => 2)
    new_story_scenes[2] = Scene.new(:position => 3)
    new_story_scenes[3] = Scene.new(:position => 4)
    new_story_scenes[4] = Scene.new(:position => 5)
   
    html = ""
    new_story_scenes.each do |s|
      html += render :partial => "scenes/edit_scene", :locals => {:scene => s}
    end
    html.html_safe
  end

  def new_story_example_text(position)
    case position
    when 1
      t 'stories.new.form.default_scenes.scene1' 
    when 2
      t 'stories.new.form.default_scenes.scene2'
    when 3
      t 'stories.new.form.default_scenes.scene3'
    when 4
      t 'stories.new.form.default_scenes.scene4'
    when 5
      t 'stories.new.form.default_scenes.scene5'
    end
  end

  # Generates text displaying the published status of a story.
  def published_status(story)
    return if story.updated_at.nil?
    t('stories.edit.last_published', timeago: timeago(story.updated_at))
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
