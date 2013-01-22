module ApplicationHelper

  def parse_story(text)
    parts = []
    parsed = text.split("{{p}}").map do |para|
      next if para.size == 0
      part = { :para => "", :scene => "" }
      if para.include? "{{s}}"
        para_parts = para.split("{{s}}")
        if para_parts[0].size > 0
          part[:scene] = markdown(para_parts[0])
        end
        part[:para] = markdown(para_parts[1])
      else
        part[:para] = markdown(para)
      end
      parts << part
    end
    parts
  end

  def markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true).render(text).html_safe
  end

end
