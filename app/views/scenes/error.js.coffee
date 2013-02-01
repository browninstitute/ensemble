$ ->
  $s = $("#scene_" + <%= @scene.id %>)
  $s.children(".scene-form").children(".scene-form-inner").children(".text-error").html("<%= @errormsg %>")
