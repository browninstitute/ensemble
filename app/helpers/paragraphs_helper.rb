module ParagraphsHelper
  # Renders like link for paragraphs. 
  def like_link(p)
    if user_signed_in? && current_user.voted_up_on?(p)
      link_to unlike_paragraph_path(p), 
        :class => "love-link loved", 
        :id => "para_#{p.id}_like_button",
        :remote => true do
        "<i class='icon-heart'></i> Loved".html_safe
      end
    elsif user_signed_in? 
      link_to like_paragraph_path(p),
        :class => "love-link",
        :id => "para_#{p.id}_like_button",
        :remote => true do
        "<i class='icon-heart'></i> Love".html_safe
      end
    else
      link_to like_paragraph_path(p),
        :class => 'love-link',
        :id => "para_#{p.id}_like_button" do
        "<i class='icon-heart'></i> Love".html_safe
      end
    end
  end
  
  # Generates CSS classes for a paragraph depending on
  # the status of paragraphs in a scene.
  def paragraphs_classes(p, scene, edit_mode = false)
    classes = ""
    classes += " multiple" if scene.paragraphs.length > 1
    classes += " unwritten" if scene.paragraphs.length < 1
    classes
  end

  # Generates destroy confirm message for paragraph
  # deletion.
  def destroy_para_confirm_message(scene)
    if !scene.open? && scene.paragraphs.length <= 1
      "Are you sure you want to delete this paragraph? Deleting this last paragraph will also remove this entire section from the story."
    else
      "Are you sure you want to delete this paragraph?"
    end
  end
end
