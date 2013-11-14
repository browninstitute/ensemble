$('#contributors_modal').remove()
$('body').append('<%= j render 'index' %>')
$('#contributors_modal').modal()

usermap = {}
$("#contributors_modal form#new_story_role #user_name").typeahead({
  updater: (username) ->
    selectedUser = usermap[username]
    $("form#new_story_role #story_role_id").val(selectedUser.id)
    $("form#new_story_role .btn").removeAttr("disabled")
    return username
  ,
  source: (query, typeahead) ->
    $("form#new_story_role .btn").attr("disabled", "disabled")
    $.get('/users/autocomplete', {query: query}, (data) ->
      usermap = {}
      usernames = []
      $.each(data, (i, user) ->
        usermap[user.name] = user
        usernames.push(user.name)
      )
      typeahead(usernames)
    )
})
