require 'format'

class Story < ActiveRecord::Base
  belongs_to :user
  attr_accessible :subtitle, :title, :public, :content

  has_many :scenes, :order => :position

  has_draft do
    attr_accessible :content
  end
  
  has_paper_trail

  after_update :destroy_draft

  validates :title, :presence => true

  # Saves a draft based on the current story text. 
  def save_draft(text)
    self.instantiate_draft! if !self.has_draft?
    self.draft.update_attributes :content => text
    self.draft
  end

  # Retrieves draft if available, otherwise gets published text.
  def draft_or_story_text
    self.has_draft? ? self.draft.content : self.content
  end

  # Destroy's current draft, if there is one
  def destroy_draft
    self.destroy_draft! if self.has_draft?
    self.has_draft? # successful if there is no draft
  end

  # Update the contents of this story (scenes and paragraphs),
  # based on JSON generated in _paragraphs.html.erb
  def update_contents(content_json)
    content = ActiveSupport::JSON.decode(content_json)
    # Update each scene, creating a new scene if no id is present
    content.each do |scene|
      scene_pos = scene['position'].to_i
      scene_obj = if scene.include? 'id'
        scene_id = scene['id'].to_i
        Scene.find(scene_id)
      else
        self.scenes.create
      end
      scene_obj.content = scene['content']
      scene_obj.insert_at(scene_pos)
      scene_obj.save!
      # Update each paragraph, creating a new paragraph attached to the scene if no id is present
      scene['paragraphs'].each do |paragraph|
        para_obj = if paragraph.include? 'id'
          para_id = paragraph['id'].to_i
          Paragraph.find(para_id)
        else
          scene_obj.paragraphs.create
        end
        para_obj.content = paragraph['content']
        para_obj.save!
      end
    end
  end

  def parse_story
    parts = self.scenes.map do |scene|
      para = scene.paragraphs[0]
      { :para => Format.markdown(para.content), :scene => Format.markdown(scene.content) }
    end
  end

end
