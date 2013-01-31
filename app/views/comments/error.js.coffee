$ ->
    $s = $("#scene_<%= @comment.scene.id %>")
  <% if @comment.id %>
    $form = $("#comment_<%= @comment.id %> form", $s)
  <% else %>
    $form = $(".comment_box form", $s)
  <% end %>
    $form.siblings(".text-error").html("<%= @errormsg %>").show()
