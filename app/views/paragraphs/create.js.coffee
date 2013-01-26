$ ->
  $s = $('#scene_<%= @scene.id %>')
  p = "<%= escape_javascript(render(:partial => 'paragraphs/paragraph', :locals => { :paragraph => @p, :scene => @scene, :paragraph_counter => 1 })) %>"
  $p = $(p)
  $content = $p.children('.paragraph-content')
  $content.html('<%= Format.markdown @p.content %>')

  $s.children(".paragraph").children(".paragraphs-container").append(p)
  console.log($s)
  console.log($s.children(".paragraph").children(".paragraphs-container"))
  $s.children('.paragraph-form').remove()

  if $s.find('.paragraph-inner').size() > 1
    $s.children('.paragraph').addClass('multiple')

  $s.children('.paragraph').show()
  goToParagraph($s.children(".paragraph").children('.paragraphs-container'), <%= @p.id %>)
