class Scene < ActiveRecord::Base
  belongs_to :user
  belongs_to :story, :touch => true
  acts_as_list :scope => :story
  has_many :paragraphs, :order => :position, :dependent => :delete_all
  has_many :comments
  attr_accessible :content, :title, :prompt, :position, :temp_id, :paragraphs
  has_paper_trail :only => [:content, :title, :prompt], :meta => {:story_id => :story_id}
  #validates :title, :presence => true, :on => :update

  # Returns true if scene is settled (has a declared winner
  # or only has one paragraph)
  def settled?
    (self.paragraphs.length == 1) || !self.winner_id.nil?
  end

  # Returns true if scene is open for contributions.
  def open?
    !self.title.blank?
  end

  # Returns an array of User records representing the
  # individuals that have written paragraphs for the scene.
  def contributors
    users = []
    self.paragraphs.each do |para|
      unless para.user_id.nil?
        user = User.find(para.user_id)
        if !users.include? user
          users.push(user)
        end
      end
    end
    users
  end

  # Returns an array of User records representing the
  # individuals that have commented on the scene.
  def commenters
    users = []
    self.comments.each do |comment|
      unless comment.user_id.nil?
        user = User.find(comment.user_id)
        if !users.include? user
          users.push(user)
        end
      end
    end
    users
  end

  # Generates temporary ID for use with AJAX callbacks on
  # newly created objects.
  def temp_id
    if @temp_id.nil?
      @temp_id = rand(1000000000)
    end
    @temp_id
  end

  def temp_id=(id)
    @temp_id = id
  end

  # Returns paragraphs ordered by votes. By default, the winning paragraph
  # for a scene will be shown first, regardless of it's vote count.
  # Paragraphs tied by vote count will be put in random order.
  #
  # order - a symbol denoting order (either :desc or :asc)
  # options
  #   :ignore_winner (boolean) - if true, shows all paragraphs in strict vote order.
  #                              false by default.
  #   :id (integer) - if not nil, shows the paragraph with the given id first, as long
  #                   as it belongs to the scene.
  #
  def ordered_paragraphs(order = :desc, options = {})
    ordered = self.paragraphs.dup 
    if order == :asc 
      ordered.sort! do |x, y| 
        if x.likes.size == y.likes.size
          rand <=> rand
        else
          x.likes.size <=> y.likes.size
        end
      end
    else # desc
      ordered.sort! do |x, y| 
        if x.likes.size == y.likes.size
          rand <=> rand
        else
          y.likes.size <=> x.likes.size
        end
      end
    end

    if options[:id]
      move = ordered.delete(Paragraph.find(options[:id]))
      ordered = ordered.unshift(move)
    elsif !options[:ignore_winner] && !self.winner_id.nil?
      move = ordered.delete(Paragraph.find(self.winner_id))
      ordered = ordered.unshift(move) 
    end

    ordered
  end
end
