$ ->
  <% @story.scenes.each do |scene| %>
  $s = $("#scene_<%= scene.id %>")
  $(".paragraphs-container", $s).html("<%= escape_javascript(render :partial => "stories/paragraph_form", :locals => {:scene => scene }) %>")
  <% end %>
  $(".story-header").replaceWith("<%= escape_javascript(render :partial => "stories/form") %>")
  $(".content").addClass("edit-mode")
  #$(".story").after("<%= escape_javascript(render :partial => "stories/form") %>")
  #$(".story").remove()
  #$(".scene-info-inner").click showScene
  #setupComments()
