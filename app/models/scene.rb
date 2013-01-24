class Scene < ActiveRecord::Base
  belongs_to :user
  belongs_to :story
  acts_as_list :scope => :story
  has_many :paragraphs, :order => :position
  attr_accessible :content, :title, :position, :paragraphs
end
