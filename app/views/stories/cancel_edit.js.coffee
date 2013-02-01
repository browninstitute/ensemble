$ ->
  $(".story-form").after("<%= escape_javascript(render :partial => 'stories/story') %>")
  $(".story-form").remove()
  $(".scene-info-inner").click showScene
  setupComments()
