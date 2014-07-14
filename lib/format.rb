class HTMLwithMedia < Redcarpet::Render::HTML
  def preprocess(full_document)
    full_document.gsub(/\[video:(.*)\]\((.*)\)/) do
      videoid = $1.strip
      caption = $2.strip
      "<p class=\"embed-video\"><iframe src=\"http://www.youtube.com/embed/#{videoid}\" frameborder=\"0\"></iframe><span class=\"caption\">#{caption}</span></p>"
    end
  end

  def image(link, title, alt_text)
    "<span class=\"embed-image\"><img src=\"#{link}\"><br /><span class=\"caption\">#{title}</span></span>"
  end
end

module Format
  def self.markdown(text)
    Redcarpet::Markdown.new(HTMLwithMedia.new, :autolink => true, :space_after_headers => true).render(text).html_safe
  end
end
