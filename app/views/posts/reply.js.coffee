$('#new_post_modal').remove()
$('body').append('<%= j render "reply" %>')
$('#new_post_modal').modal()