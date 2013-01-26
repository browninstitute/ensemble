$ ->
  $winner = $('#para_<%= @p.id %>_winner_button')
  if $winner.hasClass('winner')
    $winner.removeClass('winner')
  else
    $winner.addClass('winner')
