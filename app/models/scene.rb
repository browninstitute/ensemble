class Scene < ActiveRecord::Base
  belongs_to :user
  belongs_to :story
  acts_as_list :scope => :story
  has_many :paragraphs, :order => :position, :dependent => :delete_all
  has_many :comments
  attr_accessible :content, :title, :position, :paragraphs
  acts_as_votable

  # Returns paragraphs ordered by votes. By default, the winning paragraph
  # for a scene will be shown first, regardless of it's vote count.
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
      ordered.sort! { |x, y| x.likes.size <=> y.likes.size }
    else # desc
      ordered.sort! { |x, y| y.likes.size <=> x.likes.size }
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
