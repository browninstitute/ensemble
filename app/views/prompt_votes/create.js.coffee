$("#my-story-<%= @story.id %> .vote-button").html("<strong>Voted!</strong>")
$(".user-vote-count").html("<%= pluralize(@user_vote_count, "vote") %>")
<% if @user_vote_count == 0 %>
$(".vote-button a").attr("disabled", "disabled")
<% end %>
