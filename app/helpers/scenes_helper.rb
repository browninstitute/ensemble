module ScenesHelper
  def new_or_edit_scene_path(scene)
    if scene.nil?
      new_scene_path
    elsif scene.new_record?
      new_scene_path(:temp_id => scene.temp_id)
    else
      edit_scene_path(scene) 
    end
  end
end
