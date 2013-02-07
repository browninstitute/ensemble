class StoryRole < ActiveRecord::Base
  belongs_to :story
  belongs_to :user
  attr_accessible :role, :user_id, :story_id
end
