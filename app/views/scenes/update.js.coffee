$ ->
  $scene = $("#scene_<%= @scene.id %>")

  $scene.children(".scene-form").remove()
  $scene.children(".new-scene").remove()
  $scene.children(".scene-info").remove()
  $scene.append("<%= escape_javascript(render(:partial => 'scenes/scene_info', :locals => { :scene => @scene })) %>")
        .show()
  $scene.children(".scene-info").children(".scene-info-inner").click showScene
  $scene.addClass("open")
