$ ->
  $winner = $('#para_<%= @p.id %> .paragraph-info .winner')
  if $winner.is(':visible')
    $winner.hide()
  else
    # First make sure to unmark other paragraphs
    $paragraphs = $('#scene_<%= @p.scene.id %> .paragraph-inner .winner').hide()
     
    # Mark current paragraph as winner 
    $winner.show()
