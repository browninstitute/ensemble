class Prompt < ActiveRecord::Base
  attr_accessible :deadline, :description, :prizes, :image_credit, :image_link_url, :image_url, :opendate, :vote_deadline, :suggested_by_id, :title, :word_count

  def status
    if (vote_deadline.nil? && Time.now > self.deadline) || Time.now > self.vote_deadline
      :end
    elsif Time.now > self.deadline
      :voting
    elsif Time.now > self.opendate
      :open
    else
      :notstarted
    end
  end

  def self.current
    Prompt.where("opendate < ? AND deadline > ?", DateTime.now, DateTime.now).order(:opendate).first
  end
end
