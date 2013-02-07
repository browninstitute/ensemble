require 'format'
require 'set'

class Story < ActiveRecord::Base
  belongs_to :user
  attr_accessible :subtitle, :title, :public, :content

  has_many :scenes, :order => :position
  has_many :story_roles
  has_many :contributors, :through => :story_roles, :source => :user

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
    Scene.transaction do
      Paragraph.transaction do
        content = ActiveSupport::JSON.decode(content_json)

        # Ensure that all scene ids and paragraph ids belong to this story
        content.each do |scene|
          if scene.include? 'id'
            s = Scene.find(scene['id'].to_i)
            raise "Scene Doesn't Belong to Story" if s.story != self
            scene['paragraphs'].each do |paragraph|
              if paragraph.include? 'id'
                p = Paragraph.find(paragraph['id'].to_i)
                raise "Paragraph Doesn't Belong to Scene" if p.scene != s
              end
            end
          end
        end

        debugger

        # Delete old scenes (cascades paragraph deletion)
        existing_scene_ids = Set.new(self.scenes.map { |scene| scene.id })
        new_scene_ids = Set.new(content.map { |scene| (scene.include? 'id') ? scene['id'].to_i : 0 })
        scenes_to_delete_ids = existing_scene_ids - new_scene_ids
        scenes_to_delete_ids.each do |scene_id|
          Scene.find(scene_id).destroy
        end

        # Update each scene, creating a new scene if no id is present
        content.each do |scene|
          scene_pos = scene['position'].to_i
          scene_obj = if !scene.include? 'id'
            scene_obj = self.scenes.create
            scene_obj.insert_at(scene_pos)
            scene_obj
          else
            Scene.find(scene['id'])
          end
          scene_obj.title = scene['title']
          scene_obj.content = scene['content']
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
            para_obj.user_id = paragraph['user_id']
            para_obj.save!
          end
        end
      end
    end
  end
  
  # TODO what does this do?
  def parse_story
    parts = self.scenes.map do |scene|
      para = scene.paragraphs[0]
      { :para => para, :scene => scene }
    end
  end

end
