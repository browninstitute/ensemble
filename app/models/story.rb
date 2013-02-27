require 'format'
require 'set'

class Story < ActiveRecord::Base
  belongs_to :user
  attr_accessible :subtitle, :title, :public, :content
  has_many :scenes, :order => :position
  has_many :story_roles
  has_many :contributors, :through => :story_roles, :source => :user
  has_paper_trail :only => [:title, :subtitle]
  validates :title, :presence => true

  # Gets all Story activity as an array.
  def activity
    activity = []

    Version.find(:all, :conditions => {:item_type => "Story", :item_id => self.id}).each do |v|
      activity.push(v)
    end

    # Scenes, Paragraphs, and Comments
    Version.find(:all, :conditions => ["story_id = ? and item_type != ?", self.id, "Story"]).each do |v|
      activity.push(v)
    end

    activity.sort {|a, b| b.created_at <=> a.created_at }
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

        # Delete old scenes and their paragraphs
        existing_scene_ids = Set.new(self.scenes.map { |scene| scene.id })
        new_scene_ids = Set.new(content.map { |scene| (scene.include? 'id') ? scene['id'].to_i : 0 })
        scenes_to_delete_ids = existing_scene_ids - new_scene_ids
        scenes_to_delete_ids.each do |scene_id|
          # need to explicitly destroy paragraphs so paper_records the destroy event
          Scene.find(scene_id).paragraphs.destroy_all
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
          scene_obj.insert_at(scene_pos)
          scene_obj.save!
          
          # Update each paragraph, creating a new paragraph attached to the scene if no id is present
          scene['paragraphs'].each do |paragraph|
            para_obj = if paragraph.include? 'id'
              para_id = paragraph['id'].to_i
              Paragraph.find(para_id)
            else
              scene_obj.paragraphs.build
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
