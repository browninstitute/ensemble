$ ->
  $p = $("#para_<%= @p.id %>")
  $p.hide("slow", ->
    doNotReset = $p.parent().parent().hasClass('expanded')
    $(this).remove()
    if (!doNotReset)
      resetParagraphs($("#scene_<%= @scene.id %>").children(".paragraph").children('.paragraphs-container'))
  )
