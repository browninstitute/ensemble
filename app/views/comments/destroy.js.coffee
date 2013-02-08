$("#comment_<%= @comment.id %>").remove()
$("#scene_<%= @comment.scene.id %> .comment-count").html("<%= @comment.scene.comments.length %>")
