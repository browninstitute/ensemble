$ ->
  <% @story.scenes.each do |scene| %>
  $s = $("#scene_<%= scene.id %>")
  $(".paragraphs-container", $s).html("<%= escape_javascript(render :partial => "stories/paragraph_form", :locals => {:scene => scene }) %>")
  <% end %>
  $(".story-header").replaceWith("<%= escape_javascript(render :partial => "stories/form") %>")
  $(".content").addClass("edit-mode")
  $(".para-navigation button").unbind()
  $(".prev-paragraph").click prevTextbox
  $(".next-paragraph").click nextTextbox
