# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#story_popover').hide()
  $('#story_popover .close').click ->
    $(this).parent().offset({ top: 0, left: 0 }).hide()

  $('.content').on 'mouseup', ->
    currentRange = window.getSelection().getRangeAt(0)
    console.log currentRange
    elt = currentRange.startContainer
    startOffset = currentRange.startOffset
    endOffset = currentRange.endOffset

    if (currentRange.startContainer != currentRange.endContainer) || (currentRange.startContainer = currentRange.endContainer && startOffset != endOffset)
      elt1 = elt.nodeValue.substring(0, startOffset)
      elt2 = elt.nodeValue.substring(startOffset)
      elt.nodeValue = elt1 + "BEAD0BEAD" + elt2
      elt = currentRange.endContainer
      endOffset += "BEAD0BEAD".length if currentRange.endContainer == currentRange.startContainer
      elt2 = elt.nodeValue.substring(0, endOffset)
      elt3 = elt.nodeValue.substring(endOffset)
      elt.nodeValue = elt2 + "BEAD1BEAD" + elt3
      $elt = $(currentRange.startContainer.parentElement)
      $('.content').html($('.content').html().replace("BEAD0BEAD", "<span id=\"currently_highlighted\" class=\"highlight\">").replace("BEAD1BEAD", "</span>"))
      window.getSelection().removeAllRanges()

      console.log $('#currently_highlighted').offset()
      pos = $('#currently_highlighted').offset()
      $('#currently_highlighted').removeAttr('id')

      $('#story_popover').offset({ top: pos.top + 25, left: pos.left}).show()