module ParagraphsHelper
  # Generates CSS classes for a paragraph depending on
  # the status of paragraphs in a scene.
  def paragraphs_classes(p, scene)
    classes = ""
    classes += " multiple" if scene.paragraphs.length > 1
    classes += " unwritten" if scene.paragraphs.length < 1
    classes
  end
end
