$ ->
  $scene = $("#temp_<%= @scene.temp_id %>")

  # add form
  $scene.children(".new-scene")
        .after("<%= escape_javascript(render(:partial => 'scenes/form', :locals => {:scene => @scene, :buttons => false})) %>")
  
  # hide new scene div
  $scene.children(".new-scene").remove()

