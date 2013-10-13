$ ->
  $p = $('#para_<%= @p.id %>')
  $s = $p.parents(".scene")

  # remove other forms for the scene
  $s.children('.paragraph-form').remove()

  # add the form
  $s.find('.paragraph')
    .after("<%= escape_javascript(render(:partial => 'paragraphs/form', :locals => {:p => @p, :scene => @scene})) %>")
  $(".paragraph-form textarea", $s).placeholder()
  $('.cancel-paragraph', $s).click cancelParagraph
  $('textarea', $s).autosize().trigger('autosize')
  $s.find('.paragraph').hide()
