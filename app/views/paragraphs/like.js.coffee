$ ->
  $lb = $('#para_<%= @para.id %>_like_button')
  $lc = $('#para_<%= @para.id %>_like_count')
  if $lb.attr('disabled')
    $lb.html('<i class="icon-heart"></i> Love').removeAttr('disabled')
  else
    $lb.html('<i class="icon-heart"></i> Loved').attr('disabled', 'disabled')
  $lc.text('<%= @para.likes.size %>')
