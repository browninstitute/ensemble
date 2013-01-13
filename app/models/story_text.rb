class StoryText < ActiveRecord::Base
  belongs_to :story
  attr_accessible :content, :public, :title
end
