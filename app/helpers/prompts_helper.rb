module PromptsHelper
  def prompt_label(prompt)
    html = "<span class='label"
    if prompt.status == :open
      html += " label-success"
    elsif prompt.status == :voting
      html += " label-info"
    elsif prompt.status == :notstarted
      html += " label-warning"
    end
    html += "'>"
    
    if prompt.status == :open
      html += "Open for submissions"
    elsif prompt.status == :voting
      html += "Voting for winner"
    elsif prompt.status == :end
      html += "Ended"
    elsif prompt.status == :notstarted
      html += "Not started"
    end
    
    html += "</span>"
    html.html_safe
  end
end
