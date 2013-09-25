$('#story_comment_<%= @comment.id %>').replaceWith('<%= escape_javascript(render :partial => 'comments/story_form', :locals => {:story => @comment.story, :story_comment => @comment}) %>')
