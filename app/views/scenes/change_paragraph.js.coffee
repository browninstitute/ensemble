$ ->
  $scene = $(".scene")

  # Replace paragraph with new paragraph
  $(".paragraph-inner.active", $scene).removeClass("active").addClass("hide")
  $("#para_<%= @p.id %>", $scene).removeClass("hide").addClass("active")
  $(".paragraphs-nav li.active", $scene).removeClass("active")
  $("#para-nav-<%= @p.id %>", @scene).addClass("active")
