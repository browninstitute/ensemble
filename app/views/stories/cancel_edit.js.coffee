$ ->
  $(".story").replaceWith("<%= escape_javascript(render :partial => 'stories/story') %>")
  $(".scene-info-inner").click showScene
  $(".next-paragraph").click nextParagraph
  $(".prev-paragraph").click prevParagraph
  setupComments()
  resetAllParagraphs()
