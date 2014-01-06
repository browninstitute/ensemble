class Prompt < ActiveRecord::Base
  attr_accessible :deadline, :description, :image_credit, :image_link_url, :image_url, :opendate, :suggested_by_id, :title, :word_count

  def status
    if Time.now > self.deadline
      "Closed for submissions"
    elsif Time.now > self.opendate
      "Open for submissions"
    else
      "Not started"
    end
  end

  def self.current
    Prompt.where("opendate < ? AND deadline > ?", DateTime.now, DateTime.now).order(:opendate).first
  end
end
