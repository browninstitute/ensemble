module ParagraphsHelper
  # Generates CSS classes for a paragraph depending on
  # the status of paragraphs in a scene.
  def paragraphs_classes(p, scene, edit_mode = false)
    classes = ""
    classes += " multiple" if scene.paragraphs.length > 1
    classes += " unwritten" if scene.paragraphs.length < 1
    classes += " open" if !scene.title.blank? && !edit_mode
    classes
  end
end
