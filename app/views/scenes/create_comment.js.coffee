$('#scene_<%= @scene.id %>_comment_box').hide()
$('#scene_<%= @scene.id %>_comments').prepend("<%= escape_javascript(render :partial => "comments/comment", :locals => {:comment => @comment}) %>")
