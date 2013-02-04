module StoriesHelper
  # Generates text displaying the draft status of a story.
  def draft_status(story)
    return if story.id.nil?

    if story.has_draft? 
      "Draft last saved #{time_ago_in_words(story.draft.updated_at)} ago."
    else 
      "No draft saved."
    end
  end

  # Generates text displaying the published status of a story.
  def published_status(story)
    return if story.updated_at.nil?

    "Last published #{time_ago_in_words(story.updated_at)} ago."
  end
end
