$('#scene_<%= @scene.id %>_comment_box').hide()
$('#scene_<%= @scene.id %>_box').html('<%=j render :partial => 'scenes/scene_info', :locals => { :scene => @scene } %>')
