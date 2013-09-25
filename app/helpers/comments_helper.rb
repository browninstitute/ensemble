require "arrowhead"

module CommentsHelper
  # Fragment cache key for comments
  def cache_key_for_comments
    count          = Comment.count
    max_updated_at = Comment.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "comments/all-#{count}-#{max_updated_at}"
  end

  # Generates CSS classes for a comment depending on
  # who wrote it.
  def comments_classes(comment, is_story_comment = false)
    classes = ""
    if Arrowhead.is_arrowhead_author?(comment.user.id) && ((is_story_comment && Arrowhead.is_arrowhead_story?(comment.story)) || (!is_story_comment && Arrowhead.is_arrowhead_story?(comment.scene.story)))
      classes += " arrowhead-author-comment"
    end
    classes
  end

end
