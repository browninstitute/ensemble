$ ->
  $scene = $("#scene_<%= @scene.id %>")

  $scene.children(".scene-info")
    .replaceWith("<%= escape_javascript(render(:partial => 'scenes/new', :locals => { :scene => @scene })) %>")
  $scene.children(".new-scene").click showScene
  $scene.removeClass("open")
