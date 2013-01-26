module ParagraphsHelper
  def paragraphs_classes(p, scene)
    classes = "paragraph span8"
    classes += " multiple" if scene.paragraphs.length > 1
    classes += " unwritten" if scene.paragraphs.length < 1
    classes
  end

  def paragraph_form_classes(p, scene)
    classes = "paragraph-form span8"
    classes
  end
end
