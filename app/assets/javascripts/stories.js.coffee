# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  # Initialize
  $(".winner i").tooltip({title: "Winner!"})
  $(".scene .nav-tabs .new-paragraph").tooltip({title: "Add alternative"})
  $(".scene-info-inner .scene-header i").tooltip({title: "This scene is accepting alternatives."})

  $(".scene-info-inner").click showScene
  $(".new-scene").click showScene

  $(window).bind("load", ->
    truncateSceneDesc() # force this to only happen after CSS has loaded
  )
  setupComments()
  setupAnalytics()

  # Make functions available for AJAX callbacks
  window.setupAnalytics = setupAnalytics

  window.cancelParagraph = cancelParagraph

  window.cancelScene = cancelScene
  window.showScene = showScene

  window.setupComments = setupComments
  window.truncateSceneDesc = truncateSceneDesc

  window.nextTextbox = nextTextbox
  window.prevTextbox = prevTextbox

  window.toolbarBold = toolbarBold
  window.toolbarItalic = toolbarItalic
  window.toolbarUnorderedList = toolbarUnorderedList

# Setup custom event tracking for Google Analytics
setupAnalytics = ($tab = "all") ->
  if $tab == "all"
    $(".nav-tabs li > a").not(".new-paragraph").click (e) ->
      if !$(e.target).parent().hasClass('active')
        paragraphID = parseInt(e.target.innerHTML.match(/[0-9]+/)[0])
        _gaq.push(['_trackEvent', 'paragraphs', 'view', '', paragraphID])
  else
    # Setup analytics for a single tab
    $tab.click (e) ->
      if !$(e.target).parent().hasClass('active')
        paragraphID = parseInt(e.target.innerHTML.match(/[0-9]+/)[0])
        _gaq.push(['_trackEvent', 'paragraphs', 'view', '', paragraphID])

# Cancels paragraph editing or creation in view mode.
cancelParagraph = (e) ->
  _this = $(this)
  parent = _this.parents('.scene')
  parent.children('.paragraph').show()
  parent.children('.paragraph-form').remove()
  e.preventDefault()

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
  if (e.target == this || e.target.tagName == "H1" || e.target.tagName == "P" || e.target.className == "scene-header")
    _this = $(this)
    sceneID = parseInt(_this.parents('.scene').attr('data-id'))
    if _this.hasClass("scene-selected")
      _this.removeClass("scene-selected")
      truncateSceneDesc(_this.parents('.scene')) # .scene
      _gaq.push(['_trackEvent', 'scene', 'closeview', '', sceneID])
    else
      $(".scene-selected").removeClass("scene-selected")
      truncateSceneDesc()
      $(".cancel-scene").click()
      revertSceneDesc(_this.parents('.scene'))
      condenseComments($(".scene-comments", _this))
      _this.addClass("scene-selected")
      _gaq.push(['_trackEvent', 'scene', 'view', '', sceneID])

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
      condenseComments($(sc))

condenseComments = ($sc) ->
  totalComments = $(".comment_box", $sc).length
  count = totalComments - 2
  $(".comment_box:lt(" + count + ")", $sc).hide()
  if (count > 0)
    $(".show_more").remove()
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

truncateSceneDesc = ($scene = "all") ->
  if ($scene == "all")
    # loop
    for s in $(".scene")
      $s = $(s)
      siblings = $(".scene_text > p ~ p", $s)
      siblings.hide()
      if ($s.height() <= 140)
        $(".scene_text > p:first", $s).trunk8({lines: 1})
      else
        $(".scene_text > p:first", $s).trunk8({lines: 3})

      if siblings.length != 0
        $(".scene_text > p:first", $s).html($(".scene_text > p:first", $s).html() + "<span>&hellip;</span>")
  else
    # truncate specific scene description
    siblings = $(".scene_text > p ~ p", $scene)
    siblings.hide()
    if ($scene.height() <= 140)
      $(".scene_text > p:first", $scene).trunk8({lines: 1})
    else
      $(".scene_text > p:first", $scene).trunk8({lines: 3})

    if siblings.length != 0
      $(".scene_text > p:first", $scene).html($(".scene_text > p:first", $scene).html() + "<span>&hellip;</span>")

revertSceneDesc = ($scene) ->
  if ($(".scene_text > p", $scene).attr('title')) || $(".scene_text > p ~ p")
    $(".scene_text > p:first span").remove()
    $(".scene_text > p", $scene).show()
    $(".scene_text > p:first", $scene).trunk8('revert')

toolbarBold = ->
  $(selectedTextarea).each ->
    start = this.selectionStart;
    end = this.selectionEnd;
    if (end - start > 0)
      if $(this).val().substring(start, start + 2) == $(this).val().substring(end - 2, end) == '**'
        $(this).val(
          $(this).val().substring(0, start) +
          $(this).val().substring(start + 2, end - 2) +
          $(this).val().substring(end)
        )
        this.setSelectionRange(start, end - 4)
      else
        $(this).val(
            $(this).val().substring(0, start) +
            "**" + $(this).val().substring(start, end) + "**" +
            $(this).val().substring(end)
        )
        this.setSelectionRange(start, end + 4)

toolbarItalic = ->
  $(selectedTextarea).each ->
    start = this.selectionStart;
    end = this.selectionEnd;
    if (end - start > 0)
      if $(this).val().substring(start, start + 1) == $(this).val().substring(end - 1, end) == '_'
        $(this).val(
          $(this).val().substring(0, start) +
          $(this).val().substring(start + 1, end - 1) +
          $(this).val().substring(end)
        )
        this.setSelectionRange(start, end - 2)
      else
        $(this).val(
          $(this).val().substring(0, start) +
          "_" + $(this).val().substring(start, end) + "_" +
          $(this).val().substring(end)
        )
        this.setSelectionRange(start, end + 2)

toolbarUnorderedList = ->
  $(selectedTextarea).each ->
    start = this.selectionStart;
    end = this.selectionEnd;
    if (end - start > 0)
      $(this).val(
        $(this).val().substring(0, start) +
        "\n\n- " + $(this).val().substring(start, end) + "\n\n" +
        $(this).val().substring(end)
      )
      this.setSelectionRange(start + 2, end + 4)
