$ ->
  $scene = $("#scene_<%= @scene.id %>")

  # If editing an existing info box
  if ($(".scene-info", $scene).length > 0)
    # hide new scene div
    $scene.children(".scene-info").hide()

    # add form
    $scene.children(".scene-info")
          .after("<%= escape_javascript(render(:partial => 'scenes/form', :locals => {:scene => @scene})) %>")
  else
    $(".new-scene", $scene).hide()
    if ($(".edit-mode").length > 0)
      $(".new-scene", $scene).after("<%= escape_javascript(render(:partial => 'scenes/form', :locals => {:scene => @scene, :buttons => false})) %>")
    else
      $(".new-scene", $scene).after("<%= escape_javascript(render(:partial => 'scenes/form', :locals => {:scene => @scene})) %>")

  $scene.children(".scene-form").children(".scene-form-inner").children(".cancel-scene").click cancelScene
