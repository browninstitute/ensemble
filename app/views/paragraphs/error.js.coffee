$ ->
  $s = $("#scene_" + <%= @scene.id %>)
  $s.children(".paragraph-form").children(".text-error").html("<%= @errormsg %>")
