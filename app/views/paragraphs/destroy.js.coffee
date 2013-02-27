$ ->
  $s = $("#scene_<%= @p.scene.id %>")
  $p = $("#para_<%= @p.id %>")
  $p.fadeOut("slow", ->
    $(this).remove()
    $("li a[href='#para_<%= @p.id %>']", $s).parent().remove()
    $(".nav-tabs li:first a", $s).tab('show')
  )
