$('#contributor_count').text("<%= @story.contributors.count + 1 %>")
$('#contributors_modal .modal-body').html("<%= j render 'index_roles' %>")
