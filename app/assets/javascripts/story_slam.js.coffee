$(document).ready ->
  $(window).on("load resize", centerImage)

centerImage = ->
  container = $(".story-slam-banner")
  content = $(".banner-content")
  contentHeight = content.outerHeight()
  container.css('maxHeight', contentHeight)
  imageHeight = container.find('img').height()
  wrapperHeight = container.height()
  overlap = (wrapperHeight - imageHeight) / 2
  if overlap >= 0
    container.find('img').css('margin-top', overlap)
  else
    # ARROWHEAD: don't obscure the arrow at the top of the image
    container.find('img').css('margin-top', 0)
