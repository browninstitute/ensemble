class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :scene
  attr_accessible :content, :title
  acts_as_votable
end
