# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $(".winner").tooltip({title: "Winner!"})
  $(".next-paragraph").click nextParagraph
  $(".prev-paragraph").click prevParagraph
  $(".new-paragraph").click newParagraph
  $(".expand-paragraphs a").click toggleExpandParagraphs
  window.resetParagraphs = resetParagraphs
  window.goToParagraph = goToParagraph
  window.cancelParagraph = cancelParagraph

  $(".scene-info-inner").click showScene  
  window.cancelScene = cancelScene
  window.showScene = showScene
  
  setupComments()
  return true

nextParagraph = ->
  _this = $(this)

  return if _this.hasClass('disabled')

  current = _this.parent().parent().children(".paragraphs-container").children(".paragraph-inner:visible")
  next = current.next(".paragraph-inner")

  _this.parent().children('button').removeClass('disabled')
  if next.next(".paragraph-inner").length is 0
    _this.addClass('disabled')

  if (next.size() >= 1)
    _this.unbind()
    current.hide("slide", { direction: "up" }, 400, ->
      next.show("slide", { direction: "down" }, 400, ->
        _this.click nextParagraph
      )
    )

prevParagraph = ->
  _this = $(this)

  return if _this.hasClass('disabled')

  current = _this.parent().parent().children(".paragraphs-container").children(".paragraph-inner:visible")
  prev = current.prev(".paragraph-inner")

  _this.parent().children('button').removeClass('disabled')
  if prev.prev(".paragraph-inner").length is 0
    _this.addClass('disabled')

  if (prev.size() >= 1)
    _this.unbind()
    current.hide("slide", { direction: "down" }, 400, ->
      prev.show("slide", { direction: "up" }, 400, ->
        _this.click prevParagraph
      )
    )

newParagraph = ->
  _this = $(this)
  parent = _this.parents('.scene')
  parent.children('.paragraph').hide()
  parent.children('.paragraph-form').show()

cancelParagraph = (e) ->
  _this = $(this)
  parent = _this.parents('.scene')
  parent.children('.paragraph').show()
  parent.children('.paragraph-form').remove()
  e.preventDefault()

toggleExpandParagraphs = (e) ->
  _this = $(this)
  paragraphs = _this.parents('.scene').children('.paragraph')
  if (paragraphs.hasClass("multiple"))
    paragraphs.children(".paragraphs-container")
      .children(".paragraph-inner")
      .fadeIn()
    paragraphs.removeClass("multiple")
    paragraphs.addClass("expanded")
    _this.html("Collapse")
  else if (paragraphs.hasClass("expanded"))
    paragraphs.removeClass("expanded")
    paragraphs.addClass("multiple")
    _this.html("See all")
    resetParagraphs(paragraphs.children(".paragraphs-container"))
  e.preventDefault()

resetParagraphs = ($container) ->
  children = $container.children(".paragraph-inner")

  if ($container.children(".paragraph-inner:visible").size() == 0)
    $(children[children.length - 1]).show()

  if (children.size() <= 1)
    $container.parent(".paragraph").removeClass("multiple")
    $container.parent(".paragraph").removeClass("expanded")
    $container.parent(".paragraph").siblings(".scene-info").children(".link_actions").children(".expand-paragraphs").hide()

  resetParagraphsHelper($container)

resetParagraphsHelper = ($container) ->
  current = $container.children(".paragraph-inner:visible")
  prev = current.prev(".paragraph-inner")

  $container.siblings('button').removeClass('disabled')
  $container.siblings('.para-navigation').children('.prev-paragraph').addClass('disabled')

  if (prev.size() >= 1)
    current.hide()
    prev.show()
    resetParagraphsHelper($container)

goToParagraph = ($container, id) ->
  resetParagraphs($container)
  goToParagraphHelper($container, id)

goToParagraphHelper = ($container, id) ->
  current = $container.children(".paragraph-inner:visible")
  next = current.next(".paragraph-inner")

  $container.siblings('button').removeClass('disabled')
  if next.next(".paragraph-inner").length is 0
    $container.siblings('.para-navigation').children('.next-paragraph').addClass('disabled')

  if (next.size() >= 1 && (current.attr("id") != "para_" + id))
    current.hide()
    next.show()
    goToParagraphHelper($container, id)

cancelScene = (e) ->
  _this = $(this)
  parent = _this.parents('.scene')
  parent.children('.scene-form').remove()
  parent.children('.scene-info').show()
  e.preventDefault()

showScene = (e) ->
  if (e.target == this || e.target.tagName == "H1" || e.target.tagName == "P")
    _this = $(this)
    if _this.hasClass("scene-selected")
      _this.removeClass("scene-selected")
    else
      $(".scene-selected").removeClass("scene-selected")
      _this.addClass("scene-selected")

setupComments = ->
  for sc in $(".scene-comments")
    do (sc) ->
      $sc = $(sc)
      totalComments = $(".comment_box", $sc).length
      count = totalComments - 2
      $(".comment_box:lt(" + count + ")", $sc).hide()
      if (count > 0)
        $('<div class=\"show_more\">' + count + ' more...</div>').click( ->
          $(".comment_box", $sc).show(500)
          $(this).hide()
        ).prependTo($sc)
