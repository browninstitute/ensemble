module ApplicationHelper

  def parse_story(text)
    parsed = text.split("{{p}}").join("\n\n")
    markdown parsed
  end

  def markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true).render(text).html_safe
  end

end
