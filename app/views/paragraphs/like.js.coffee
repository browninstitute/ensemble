$ ->
  $lb = $('#para_<%= @para.id %>_like_button')
  $lc = $('#para_<%= @para.id %>_like_count')
  if $lb.hasClass('loved')
    $lb.html('<i class="icon-heart"></i> Love').removeClass('loved')
  else
    $lb.html('<i class="icon-heart"></i> Loved').addClass('loved')
  $lc.text('<%= @para.likes.size %>')
