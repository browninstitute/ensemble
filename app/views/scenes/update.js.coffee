$ ->
  $s = $("#scene_<%= @scene.id %>")

  $(".scene-form", $s).remove()
  $(".new-scene", $s).remove()
  $(".scene-info", $s).remove()
  $s.append("<%= escape_javascript(render(:partial => 'scenes/scene_info', :locals => { :scene => @scene })) %>")
        .show()
  $(".scene-form input, .scene-form textarea", $s).placeholder()
  $(".scene-info .scene-info-inner", $s).click showScene
  $s.addClass("open")
  truncateSceneDesc($s)

  $(".nav-tabs", $s).show()

