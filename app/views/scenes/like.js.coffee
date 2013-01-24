$ ->
  $lb = $('#scene_<%= @scene.id %>_like_button')
  $lc = $('#scene_<%= @scene.id %>_like_count')
  if $lb.attr('disabled')
    $lb.html('<i class="icon-heart"></i> Love').removeAttr('disabled')
  else
    $lb.html('<i class="icon-heart"></i> Loved').attr('disabled', 'disabled')
  $lc.text('<%= @scene.likes.size %>')
