$ ->
  $scene = $("#scene_<%= @scene.id %>")

  # hide new scene div
  $scene.children(".scene-info").hide()

  # add form
  $scene.children(".scene-info")
        .after("<%= escape_javascript(render(:partial => 'scenes/form', :locals => {:scene => @scene})) %>")
  $scene.children(".scene-form").children(".scene-form-inner").children(".cancel-scene").click cancelScene
