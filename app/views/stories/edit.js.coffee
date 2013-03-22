$ ->
  <% @story.scenes.each do |scene| %>
  $s = $("#scene_<%= scene.id %>")
  $s.replaceWith("<%= escape_javascript(render :partial => "scenes/scene", :locals => {:scene => scene, :edit_mode => true}) %>")
  <% end %>
  $(".story-header").replaceWith("<%= escape_javascript(render :partial => "stories/form") %>")
  $(".story .navbar").remove()
  $(".content").addClass("edit-mode")
  $('#add-scene-wrapper').show()
  $("input, textarea").placeholder()

  $('.content').sortable({
      handle: '.move',
      stop: ->
        paragraphsToContent()
  })
