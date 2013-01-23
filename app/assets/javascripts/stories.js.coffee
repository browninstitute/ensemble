# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $(".next-paragraph").click (e) ->
    current = $(e.target).parent().children(".paragraph-inner:visible")
    next = current.next(".paragraph-inner")
    $(this).addClass('disabled') if next.size() is 1
    if (next.size() >= 1) 
      current.hide("slide", { direction: "left" }, 400, ->
        next.show("slide", { direction: "right" }, 400)
      )

  $(".prev-paragraph").click (e) ->
    current = $(e.target).parent().children(".paragraph-inner:visible")
    prev = current.prev(".paragraph-inner")
    if (prev.size() >= 1)
      current.hide("slide", { direction: "right" }, 400, ->
        prev.show("slide", { direction: "left" }, 400)
      )
