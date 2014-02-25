module ParagraphsHelper
  # Renders like link for paragraphs. 
  def like_link(p)
    if user_signed_in? && current_user.voted_up_on?(p)
      link_to unlike_paragraph_path(p), 
        :class => "love-link loved", 
        :id => "para_#{p.id}_like_button",
        :remote => true do
        "<i class='icon-heart'></i> #{t('paragraphs.show.loved')}".html_safe
      end
    elsif user_signed_in? 
      link_to like_paragraph_path(p),
        :class => "love-link",
        :id => "para_#{p.id}_like_button",
        :remote => true do
        "<i class='icon-heart'></i> #{t('paragraphs.show.love')}".html_safe
      end
    else
      link_to like_paragraph_path(p),
        :class => 'love-link',
        :id => "para_#{p.id}_like_button" do
        "<i class='icon-heart'></i> #{t('paragraphs.show.love')}".html_safe
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
      t 'paragraphs.destroy.last_confirm'
    else
      t 'paragraphs.destroy.confirm'
    end
  end
end
