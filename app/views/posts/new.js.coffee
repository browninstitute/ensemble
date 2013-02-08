$('#new_post_modal').remove()
$('body').append('<%= j render "new" %>')
$('#new_post_modal').modal()