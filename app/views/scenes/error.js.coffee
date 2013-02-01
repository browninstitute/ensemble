$ ->
  $s = $("#scene_" + <%= @scene.id %>)
  $s.children(".scene-form").children(".text-error").html("<%= @errormsg %>")
