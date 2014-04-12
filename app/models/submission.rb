class Submission < ActiveRecord::Base
  attr_accessible :content, :genre1, :genre2, :story_id, :subtitle, :title, :user_id
  belongs_to :user
  belongs_to :story

  def word_count
    self.content.split.size 
  end

  def is_draft?
    self.story.is_draf?
  end

  def privacy
    self.story.privacy
  end
end
