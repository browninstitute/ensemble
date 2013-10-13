$ ->
  $p = $('#para_<%= @p.id %>')
  $content = $p.find('.paragraph-content')
  $content.html('<%= Format.markdown @p.content %>')

  $p.parents('.scene').find('.paragraph-form').remove()

  $p.parents('.scene').find('.paragraph').show()
