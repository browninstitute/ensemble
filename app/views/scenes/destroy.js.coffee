$ ->
  $s = $("#scene_<%= @scene.id %>")

  $(".scene-info", $s)
    .replaceWith("<%= escape_javascript(render(:partial => 'scenes/new', :locals => { :scene => @scene })) %>")
  $(".new-scene", $s).click showScene
  $s.removeClass("open")
  $(".nav-tabs", $s).hide()
