$ ->
  $lb = $('#para_<%= @para.id %>_like_button')
  $lc = $('#para_<%= @para.id %>_like_count')
  if $lb.hasClass('loved')
    console.log("unloved...")
    $lb.html('<i class="icon-heart"></i> <%= t "paragraphs.show.love" %>').removeClass('loved').attr("href", "<%= like_paragraph_path(@para) %>")
  else
    console.log("love!")
    $lb.html('<i class="icon-heart"></i> <%= t "paragraphs.show.loved" %>').addClass('loved').attr("href", "<%= unlike_paragraph_path(@para) %>")
  $lc.text('<%= @para.likes.size %>')
