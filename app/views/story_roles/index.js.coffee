$('#contributors_modal').remove()
$('body').append('<%= j render 'index' %>')
$('#contributors_modal').modal()