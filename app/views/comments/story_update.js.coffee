$('#story_comment_<%= @comment.id %>').replaceWith('<%= escape_javascript(render :partial => "comments/story_comment", :locals => {:story => @comment.story, :story_comment => @comment }) %>')
paragraphLinksHelper($("#story_comment_<%= @comment.id %>_content"))
