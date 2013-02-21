class Paragraph < ActiveRecord::Base
  belongs_to :user
  belongs_to :scene
  acts_as_list :scope => :scene
  attr_accessible :content, :position, :title
  validates :content, :presence => true, :if => lambda {|p| p.user != p.scene.story.user}
  has_paper_trail :only => [:content], :meta => {:scene_id => :scene_id}
  acts_as_votable

  before_destroy :paragraph_cleanup

  def set_as_winner
    self.scene.winner_id = self.id
    self.scene.save
  end

  def unset_as_winner
    self.scene.winner_id = nil
    self.scene.save
  end

  def is_winner?
    self.scene.winner_id == self.id
  end

  # Checks if the deleted paragraph is a winner,
  # and if so, removes the winning id from the scene.
  def paragraph_cleanup
    if self.scene.winner_id == self.id
      self.scene.winner_id = nil
      self.scene.save
    end
  end
end
