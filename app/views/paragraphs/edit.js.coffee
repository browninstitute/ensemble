$ ->
  $p = $('#para_<%= @p.id %>')
  
  # remove other forms for the scene
  $p.parents('.scene').children('.paragraph-form').remove()

  # add the form
  $p.parents('.scene').children('.paragraph')
    .after("<%= escape_javascript(render(:partial => 'paragraphs/form', :locals => {:p => @p, :scene => @scene})) %>")
  $p.parents('.scene').children('.paragraph-form').children('.cancel-paragraph').click cancelParagraph
  $p.parents('.scene').children('.paragraph').hide()
