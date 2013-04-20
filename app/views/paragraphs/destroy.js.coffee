$ ->
  $s = $("#scene_<%= @p.scene.id %>")
  $p = $("#para_<%= @p.id %>")
  $p.fadeOut("slow", ->
    $(this).remove()
    <% if @scene.paragraphs.length == 0 %>
    $s.remove()
    <% else %>
    $("li a[href='#para_<%= @p.id %>']", $s).parent().remove()
    $(".nav-tabs li:first a", $s).tab('show')
    <% end %>
  )
