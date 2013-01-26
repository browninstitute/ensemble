$ ->
  $p = $('#para_<%= @p.id %>')
  $p.parents('.scene').children('.paragraph')
    .after("<%= escape_javascript(render(:partial => 'paragraphs/form', :locals => {:p => @p, :scene => @scene})) %>")
  $p.parents('.scene').children('.paragraph-form').children('.cancel-paragraph').click cancelParagraph
  $p.parents('.scene').children('.paragraph').hide()
