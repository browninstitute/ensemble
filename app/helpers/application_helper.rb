module ApplicationHelper

  def parse_story(text)
    parsed = text.split("{{p}}").map do |para|
      if para.include? "{{s}}"
        parts = para.split("{{s}}")
        if parts[0].size > 0
          "### " + parts[0] + "\n\n" + parts[1]
        else
          parts[1]
        end
      else
        para
      end
    end

    markdown(parsed.join("\n\n"))
  end

  def markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true).render(text).html_safe
  end

end
