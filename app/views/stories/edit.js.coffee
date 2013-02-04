$ ->
  <% @story.scenes.each do |scene| %>
  $s = $("#scene_<%= scene.id %>")
  $s.replaceWith("<%= escape_javascript(render :partial => "scenes/scene", :locals => {:scene => scene, :edit_mode => true}) %>")
  <% end %>
  $(".story-header").replaceWith("<%= escape_javascript(render :partial => "stories/form") %>")
  $(".content").addClass("edit-mode")
  $(".para-navigation button").unbind()
  $(".prev-paragraph").click prevTextbox
  $(".next-paragraph").click nextTextbox
