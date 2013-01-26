class Paragraph < ActiveRecord::Base
  belongs_to :user
  belongs_to :scene
  acts_as_list :scope => :scene
  attr_accessible :content, :position, :title
  validates :content, :presence => true
  acts_as_votable
end
