$ ->
  $s = $('#scene_<%= @scene.id %>')
  p = "<%= escape_javascript(render(:partial => 'paragraphs/paragraph', :locals => { :paragraph => @p, :scene => @scene, :paragraph_counter => 1 })) %>"
  $p = $(p)
  $content = $('.paragraph-content', $p)
  $content.html('<%= Format.markdown @p.content %>')

  $(".tab-content", $s).append(p)
  $('.paragraph-form', $s).remove()
  $(".nav-tabs li:last", $s).before("<li><a href='#para_<%= @p.id %>' data-toggle='tab'>#<%= @p.id %></a></li>")
  $(".nav-tabs li:nth-last-child(2) a", $s).tab('show')
  setupAnalytics($(".nav-tabs li:nth-last-child(2) a", $s))

  $('.paragraph', $s).show()
