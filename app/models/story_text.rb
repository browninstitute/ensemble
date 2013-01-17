class StoryText < ActiveRecord::Base
  belongs_to :story
  attr_accessible :content 
  has_draft do
    attr_accessible :content
  end
  has_paper_trail
end
