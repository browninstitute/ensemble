$("#story_comment_<%= @comment.id %>").remove()
$("#story_<%= @comment.story.id %>_comments .comment-count").html("<%= pluralize @comment.story.comments.length, "comment" %>")
