class Story < ActiveRecord::Base
  belongs_to :user
  attr_accessible :subtitle, :title, :public

  validates :title, :presence => true

  after_create :create_story_text
  after_destroy :destroy_story_texts

  # Retrieves the most recent version of the story's text.
  def story_text
    StoryText.find(:first, :order => 'updated_at DESC').content
  end

  # Create a StoryText object to go with the Story object.
  def create_story_text
    @story_text = StoryText.new :content => "Fill in your story here!"
    @story_text.story_id = id
    @story_text.save
  end

  # Destroy StoryText objects related to the Story object.
  def destroy_story_texts
    StoryText.destroy_all(:story_id => id)
  end
end
