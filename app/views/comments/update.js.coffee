$('#comment_<%= @comment.id %>').replaceWith('<%= escape_javascript(render :partial => "comments/comment", :locals => {:scene => @comment.scene, :comment => @comment }) %>')
paragraphLinksHelper($("#comment_<%= @comment.id %>_content"))
$("abbr.timeago", "#comment_<%= @comment.id %>").timeago();
