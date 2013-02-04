module ScenesHelper
  def new_or_edit_scene_path(scene)
    scene.nil? or scene.new_record? ? new_scene_path : edit_scene_path(scene) 
  end
end
