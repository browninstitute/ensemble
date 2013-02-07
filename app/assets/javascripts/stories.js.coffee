# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  # Initialize 
  $(".winner").tooltip({title: "Winner!"})
  $(".next-paragraph").click nextParagraph
  $(".prev-paragraph").click prevParagraph
  $(".new-paragraph").click newParagraph
  $(".expand-paragraphs a").click toggleExpandParagraphs
  
  $(".scene-info-inner").click showScene
  $(".new-scene").click showScene
  
  setupComments()
  
  # Make functions available for AJAX callbacks
  window.nextParagraph = nextParagraph
  window.prevParagraph = prevParagraph
  window.resetAllParagraphs = resetAllParagraphs
  window.resetParagraphs = resetParagraphs
  window.goToParagraph = goToParagraph
  window.cancelParagraph = cancelParagraph
  window.toggleExpandParagraphs = toggleExpandParagraphs

  window.cancelScene = cancelScene
  window.showScene = showScene

  window.setupComments = setupComments

  window.nextTextbox = nextTextbox
  window.prevTextbox = prevTextbox

# Moves to the next paragraph of a scene, in view mode.
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

# Moves to the previous paragraph of a scene, in view mode.
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

# Shows the new paragraph form in view mode.
newParagraph = ->
  _this = $(this)
  parent = _this.parents('.scene')
  parent.children('.paragraph').hide()
  parent.children('.paragraph-form').show()

# Cancels paragraph editing or creation in view mode.
cancelParagraph = (e) ->
  _this = $(this)
  parent = _this.parents('.scene')
  parent.children('.paragraph').show()
  parent.children('.paragraph-form').remove()
  e.preventDefault()

# Toggles paragraphs from single to multiple view.
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

# Resets a scene to show the first paragraph.
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

  $container.siblings('.para-navigation').children('button').removeClass('disabled')
  $container.siblings('.para-navigation').children('.prev-paragraph').addClass('disabled')

  if (prev.size() >= 1)
    current.hide()
    prev.show()
    resetParagraphsHelper($container)

# Resets all scenes to show the first paragraph.
resetAllParagraphs = ->
  $(".paragraphs-container").each ->
    resetParagraphs($(this))

# Jumps to the paragraph with the given ID in the given scene.
goToParagraph = ($container, id) ->
  resetParagraphs($container)
  goToParagraphHelper($container, id)

goToParagraphHelper = ($container, id) ->
  current = $container.children(".paragraph-inner:visible")
  next = current.next(".paragraph-inner")

  $container.siblings('.para-navigation').children('button').removeClass('disabled')
  if next.next(".paragraph-inner").length is 0
    $container.siblings('.para-navigation').children('.next-paragraph').addClass('disabled')

  if (next.size() >= 1 && (current.attr("id") != "para_" + id))
    current.hide()
    next.show()
    goToParagraphHelper($container, id)

# Cancels editing of a scene in view mode.
cancelScene = (e) ->
  _this = $(this)
  parent = _this.parents('.scene')
  parent.children('.scene-form').remove()
  if parent.children('.scene-info').length > 0
    parent.children('.scene-info').show()
  else
    parent.children('.new-scene').show()
  e.preventDefault()

# Shows a scene's details.
showScene = (e) ->
  if (e.target == this || e.target.tagName == "H1" || e.target.tagName == "P")
    _this = $(this)
    if _this.hasClass("scene-selected")
      _this.removeClass("scene-selected")
    else
      $(".scene-selected").removeClass("scene-selected")
      $(".cancel-scene").click()
      _this.addClass("scene-selected")

# Condenses a scene's comments so it's not a huge list.
# Also sets up Comment shortcut link.
setupComments = ->
  $(".comment-link").unbind().click (e) ->
    $s = $(this).parent().parent().parent(); # .scene-info-inner
    if !$s.hasClass('scene-selected')
      $s.click()
    $("#comment_content", $s).focus()
    e.preventDefault()

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

# Goes to the next textbox in edit mode.
nextTextbox = ->
  _this = $(this)

  return if _this.hasClass('disabled')

  current = _this.parent().parent().children(".paragraphs-container").children("textarea:visible")
  next = current.next("textarea")

  _this.parent().children('button').removeClass('disabled')
  if next.next("textarea").length is 0
    _this.addClass('disabled')

  if (next.size() >= 1)
    _this.unbind()
    current.hide("slide", { direction: "up" }, 400, ->
      next.show("slide", { direction: "down" }, 400, ->
        _this.click nextTextbox
      )
    )

# Goes to the previous textbox in edit mode.
prevTextbox = ->
  _this = $(this)

  return if _this.hasClass('disabled')

  current = _this.parent().parent().children(".paragraphs-container").children("textarea:visible")
  prev = current.prev("textarea")

  _this.parent().children('button').removeClass('disabled')
  if prev.prev("textarea").length is 0
    _this.addClass('disabled')

  if (prev.size() >= 1)
    _this.unbind()
    current.hide("slide", { direction: "down" }, 400, ->
      prev.show("slide", { direction: "up" }, 400, ->
        _this.click prevTextbox
      )
    )
