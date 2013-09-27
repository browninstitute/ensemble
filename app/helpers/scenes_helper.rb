module ScenesHelper
  # Generates the route for a scene depending
  # on its status.
  def new_or_edit_scene_path(scene)
    if scene.nil?
      new_scene_path
    elsif scene.new_record?
      new_scene_path(:temp_id => scene.temp_id)
    else
      edit_scene_path(scene) 
    end
  end

  # Get's ID for sceen in story edit form
  def scene_id_helper(scene)
    if scene.new_record?
      "temp_#{scene.temp_id}"
    else
      "scene_#{scene.id}"
    end
  end
end
