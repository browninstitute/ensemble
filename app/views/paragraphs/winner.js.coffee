$ ->
  $winner = $('#para_<%= @p.id %> .paragraph-info .winner')
  if $winner.is(':visible')
    $winner.hide()
    $("#para_<%= @p.id %>_winner_button").html("Mark as winner")
  else
    # First make sure to unmark other paragraphs
    $paragraphs = $('#scene_<%= @p.scene.id %> .paragraph-inner .winner').hide()
     
    $("#para_<%= @p.id %>_winner_button").html("Unmark as winner")

    # Mark current paragraph as winner 
    $winner.show()
