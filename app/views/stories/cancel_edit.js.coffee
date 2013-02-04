$ ->
  $(".story").replaceWith("<%= escape_javascript(render :partial => 'stories/story') %>")
  $(".scene-info-inner").click showScene
  setupComments()
