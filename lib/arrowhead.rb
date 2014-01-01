module Arrowhead
  def self.is_arrowhead_story?(story)
    ARROWHEAD_USERIDS.include?(story.user_id) && story.title.include?("Arrowhead")
  end

  def self.is_arrowhead_author?(user_id)
    ARROWHEAD_USERIDS.include? user_id
  end

  def self.stories
    Story.find_published( :order => "title", :conditions => ["stories.user_id IN (?) AND title LIKE ?", ARROWHEAD_USERIDS, "Arrowhead%"])
  end
end
