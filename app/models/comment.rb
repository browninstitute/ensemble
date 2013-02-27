class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :scene
  attr_accessible :content, :title
  has_paper_trail :only => [:content], :meta => {:scene_id => :scene_id}
  validates :content, :presence => true
  is_impressionable
end
