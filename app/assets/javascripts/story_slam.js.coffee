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
  container.find('img').css('margin-top', overlap)
