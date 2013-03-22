$ ->
  $scene = $("#scene_<%= @scene.id %>")

  # If editing an existing info box
  if ($(".scene-info", $scene).length > 0)
    # hide new scene div
    $(".scene-info", $scene).hide()

    # add form
    $(".scene-info", $scene)
          .after("<%= escape_javascript(render(:partial => 'scenes/form', :locals => {:scene => @scene})) %>")
  # If editing a new info box
  else
    $(".new-scene", $scene).hide()
    if ($(".edit-mode").length > 0)
      $(".new-scene", $scene).after("<%= escape_javascript(render(:partial => 'scenes/form', :locals => {:scene => @scene, :buttons => false})) %>")
      $(".nav-tabs", $scene).show()
    else
      $(".new-scene", $scene).after("<%= escape_javascript(render(:partial => 'scenes/form', :locals => {:scene => @scene})) %>")

      # Close any open scenes
      $(".scene-selected").removeClass("scene-selected")
      $(".cancel-scene").click()
      truncateSceneDesc()

  $(".scene-form input, .scene-form textarea", $scene).placeholder()
  $(".scene-form .scene-form-inner .cancel-scene", $scene).click cancelScene
