$ ->
  $p = $('#para_<%= @p.id %>')

  # remove other forms for the scene
  $p.parents('.scene').children('.paragraph-form').remove()

  # add the form
  $p.parents('.scene').children('.paragraph')
    .after("<%= escape_javascript(render(:partial => 'paragraphs/form', :locals => {:p => @p, :scene => @scene})) %>")
  $('.cancel-paragraph', $p.parents('.scene')).click cancelParagraph
  $('textarea', $p.parents('.scene')).autosize().trigger('autosize')
  $p.parents('.scene').children('.paragraph').hide()
