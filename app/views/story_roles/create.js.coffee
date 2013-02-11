$('#contributor_count').text("<%= @story.contributors.count %>")
$('#contributors_modal .modal-body').html("<%= j render 'index_roles' %>")