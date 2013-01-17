module StoriesHelper
  def draft_status(story)
    story_text = story.story_text_object
    if story_text.has_draft? 
      "Draft last saved #{time_ago_in_words(story_text.draft.updated_at)} ago."
    else 
      "No draft saved."
    end
  end

  def published_status(story)
    story_text = story.story_text_object
    "Last published #{time_ago_in_words(story_text.created_at)} ago."
  end
end
