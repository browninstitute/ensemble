$ ->
  $scene = $(".scene")

  # Replace paragraph nav with new one
  $(".paragraphs-nav ul", $scene).replaceWith("<%= escape_javascript(render(:partial => "scenes/paragraph_nav", :locals => {:scene => @scene, :paragraphs => @paragraphs})) %>")

  # Update the paragraph so the first in the order is visible
  $(".paragraph-inner.active", $scene).removeClass("active").addClass("hide")
  $("#para_<%= @paragraphs.first.id %>", $scene).removeClass("hide").addClass("active")
