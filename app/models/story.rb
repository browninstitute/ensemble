class Story < ActiveRecord::Base
  belongs_to :user
  attr_accessible :subtitle, :title, :public, :content

  has_many :scenes, :order => :position

  has_draft do
    attr_accessible :content
  end
  
  has_paper_trail

  after_update :destroy_draft

  validates :title, :presence => true

  # Saves a draft based on the current story text. 
  def save_draft(text)
    self.instantiate_draft! if !self.has_draft?
    self.draft.update_attributes :content => text
    self.draft
  end

  # Retrieves draft if available, otherwise gets published text.
  def draft_or_story_text
    self.has_draft? ? self.draft.content : self.content
  end

  # Destroy's current draft, if there is one
  def destroy_draft
    self.destroy_draft! if self.has_draft?
    self.has_draft? # successful if there is no draft
  end
end
