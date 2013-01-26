$('#scene_<%= @scene.id %>_comment_box').hide()
$('#scene_<%= @scene.id %>_box').html('<%=j render :partial => 'stories/story_scene', :locals => { :scene => @scene } %>')