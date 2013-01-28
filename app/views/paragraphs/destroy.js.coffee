$ ->
  $p = $("#para_<%= @p.id %>")
  $p.hide("slow", ->
    $(this).remove()
    resetParagraphs($("#scene_<%= @scene.id %>").children(".paragraph").children('.paragraphs-container'))
  )
