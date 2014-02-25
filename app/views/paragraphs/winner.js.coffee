$ ->
  $winner = $('#para_<%= @p.id %> .paragraph-info .winner')
  if $winner.is(':visible')
    $winner.hide()
    $("#para_<%= @p.id %>_winner_button").html("<%= t('paragraphs.show.winner') %>").attr("href", "<%= winner_paragraph_path(@p) %>")
  else
    # First make sure to unmark other paragraphs
    $paragraphs = $('#scene_<%= @p.scene.id %> .paragraph-inner .winner').hide()

    $("#para_<%= @p.id %>_winner_button").html("<%= t('paragraphs.show.unwinner') %>").attr("href", "<%= unwinner_paragraph_path(@p) %>")

    # Mark current paragraph as winner
    $winner.show()
