class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :story
  attr_accessible :message, :parent_id, :pinned, :title
  has_ancestry
  is_impressionable
  acts_as_readable :on => :created_at

  # Gets the created_at of the most recently created post in the thread.
  def last_created
    self.subtree.map { |child| child.updated_at }.max
  end

  # Gets the updated_at of the most recently updated post in the thread.
  def last_updated
    self.subtree.map { |child| child.updated_at }.max
  end

  # Returns true if itself or any of its children are 
  # unread by the given user.
  def thread_unread?(user)
    self.unread?(user) || self.descendants.reduce(false) { |so_far, post| so_far || post.unread?(user) }
  end

  # Marks itself and any children as read by the given
  # user.
  def mark_thread_as_read!(user)
    self.mark_as_read! :for => user
    self.descendants.each do |post|
      post.mark_as_read! :for => user
    end
  end

  # Retrieves posts in order of last_created.
  def self.ordered_posts(story)
    posts = Post.where(:story_id => story, :ancestry => nil)
    posts.sort! { |a, b| b.last_created <=> a.last_created }
  end
end
