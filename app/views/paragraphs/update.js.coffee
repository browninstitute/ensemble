$ ->
  $p = $('#para_<%= @p.id %>')
  $content = $p.children('.paragraph-content')
  $content.html('<%= Format.markdown @p.content %>')

  $p.parents('.scene').children('.paragraph-form').remove()

  $p.parents('.scene').children('.paragraph').show()
