require "arrowhead"

module CommentsHelper
  # Generates CSS classes for a comment depending on
  # who wrote it.
  def comments_classes(comment, is_story_comment = false)
    classes = ""
    if StoryCollab::Application.config.arrowhead && Arrowhead.is_arrowhead_author?(comment.user.id) && ((is_story_comment && Arrowhead.is_arrowhead_story?(comment.story)) || (!is_story_comment && Arrowhead.is_arrowhead_story?(comment.scene.story)))
      classes += " arrowhead-author-comment"
    end
    classes
  end

end
