class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :story
  attr_accessible :message, :parent_id, :pinned, :title
  has_ancestry
  is_impressionable

  def last_updated
    self.subtree.map { |child| child.updated_at }.max
  end
end
