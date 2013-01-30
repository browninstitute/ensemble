module ParagraphsHelper
  def paragraphs_classes(p, scene)
    classes = ""
    classes += " multiple" if scene.paragraphs.length > 1
    classes += " unwritten" if scene.paragraphs.length < 1
    classes
  end
end
