$ ->
  $s = $('#scene_<%= @scene.id %>')
  
  $s.children('.paragraph')
    .after("<%= escape_javascript(render(:partial => 'paragraphs/form', :locals => {:p => @p, :scene => @scene})) %>")
  $s.children('.paragraph-form').click cancelParagraph
  $s.children('.paragraph').hide()
