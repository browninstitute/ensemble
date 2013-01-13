class Story < ActiveRecord::Base
  belongs_to :user
  attr_accessible :subtitle, :title, :public

  validates :title, :presence => true
end
