class StoryFlag < ActiveRecord::Base
  attr_accessible :user_id, :story_id, :reason
end
