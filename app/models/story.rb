class Story < ActiveRecord::Base
  belongs_to :user
  attr_accessible :subtitle, :title, :public, :story_text

  validates :title, :presence => true

  after_create :create_story_text
  after_destroy :destroy_story_texts

  # Retrieves the currently associated StoryText object
  def story_text_object
    @story_text = StoryText.find(:first, :conditions => { :story_id => id }, :order => 'updated_at DESC')
  end

  # Retrieves the story's text.
  def story_text
    @story_text = story_text_object
    @story_text.nil? ? "" : @story_text.content
  end

  # Saves a new version of the story's text.
  def story_text=(text)
    @story_text = StoryText.new :content => text
    @story_text.story_id = id
    @story_text.save
  end

  # On Story create, gives the StoryText the right ID.
  def create_story_text
    @story_text.story_id = id
    @story_text.save
  end

  # Destroy StoryText objects related to the Story object.
  def destroy_story_texts
    StoryText.destroy_all(:story_id => id)
  end

  # Saves a draft based on the current story text. 
  def save_draft(text)
    @story_text = story_text_object
    @story_text.instantiate_draft! if !@story_text.has_draft?
    @story_text.draft.update_attributes :content => text
  end

  # Retrieves draft if available, otherwise gets published text.
  def draft_or_story_text
    @story_text = story_text_object
    @story_text.has_draft? ? @story_text.draft.content : @story_text.content
  end

  # Destroy's current draft, if there is one
  def destroy_draft
    @story_text = story_text_object
    @story_text.destroy_draft! if @story_text.has_draft?
    !@story_text.has_draft? # successful if there is no draft
  end
end
