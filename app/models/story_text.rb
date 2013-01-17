class StoryText < ActiveRecord::Base
  belongs_to :story
  attr_accessible :content, :public, :title
  has_draft do
    attr_accessible :content
  end
end
