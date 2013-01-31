$('#scene_<%= @scene.id %>_comments').append("<%= escape_javascript(render :partial => "comments/comment", :locals => {:scene => @scene, :comment => @comment}) %>")
