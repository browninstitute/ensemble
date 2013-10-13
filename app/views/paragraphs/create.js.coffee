$ ->
  $s = $('#scene_<%= @scene.id %>')
  p = "<%= escape_javascript(render(:partial => 'paragraphs/paragraph', :locals => { :paragraph => @p, :scene => @scene, :paragraph_counter => 1, :show_title => @sceneview })) %>"
  $p = $(p)
  $content = $('.paragraph-content', $p)
  $content.html('<%= Format.markdown @p.content %>')

  <% if @sceneview %>
  $(".paragraphs-nav .header h1").html("<%= @scene.paragraphs.count %> Drafts")
  $(".paragraphs-container", $s).append(p)
  $(".paragraphs-nav ul li:last", $s).before("<%= escape_javascript(render(:partial => "scenes/paragraph_nav_item", :locals => {:paragraph_nav_item => @p, :paragraph_nav_item_counter => 1, :scene => @scene})) %>")
  $(".paragraphs-nav #para-nav-<%= @p.id %>", $s).click()
  <% else %>
  $(".tab-content", $s).append(p)
  $(".nav-tabs li:last", $s).before("<li><a href='#para_<%= @p.id %>' data-toggle='tab'>#<%= @p.id %></a></li>")
  $(".nav-tabs li:nth-last-child(2) a", $s).tab('show')
  setupAnalytics($(".nav-tabs li:nth-last-child(2) a", $s))
  <% end %>
  $('.paragraph-form', $s).remove()
  $('.paragraph', $s).show()
