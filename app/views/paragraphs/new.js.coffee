$ ->
  $s = $('#scene_<%= @scene.id %>')

  # remove any other forms for the scene
  $s.find('.paragraph-form').remove()

  # add the form
  $s.find('.paragraph')
    .after("<%= escape_javascript(render(:partial => 'paragraphs/form', :locals => {:p => @p, :scene => @scene})) %>")
  $(".paragraph-form textarea", $s).placeholder()
  $s.find('.paragraph-form .cancel-paragraph').click cancelParagraph
  $s.find('.paragraph').hide()
