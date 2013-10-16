class StoryRole < ActiveRecord::Base
  belongs_to :story
  belongs_to :user, :touch => true
  attr_accessible :role, :user_id, :story_id
  has_paper_trail :only => [:role], :meta => {:story_id => :story_id}
end
