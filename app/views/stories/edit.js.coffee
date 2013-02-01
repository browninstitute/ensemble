$ ->
  $(".story").after("<%= escape_javascript(render :partial => "stories/form") %>")
  $(".story").remove()
  $(".scene-info-inner").click showScene
  setupComments()
