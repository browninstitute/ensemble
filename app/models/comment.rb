class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :scene, :touch => true
  belongs_to :story
  attr_accessible :content, :title, :scene_id
  has_paper_trail :only => [:content], :meta => {:scene_id => :scene_id}
  validates :content, :presence => true
  is_impressionable
end
