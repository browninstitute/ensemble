$('#scene_<%= @scene.id %>_comments').append("<%= escape_javascript(render :partial => "comments/comment", :locals => {:scene => @scene, :comment => @comment}) %>")
paragraphLinksHelper($("#comment_<%= @comment.id %>_content"))
$("#scene_<%= @scene.id %> #comment_content").val("")
$("#scene_<%= @scene.id %> .comment_box .text-error").html("")
$("#scene_<%= @scene.id %> .comment-count").html("<%= @scene.comments.length %>")
$("#comment_<%= @comment.id %> abbr.timeago").timeago();
