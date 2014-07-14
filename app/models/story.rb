require 'format'
require 'set'

class Story < ActiveRecord::Base
  class Privacy
    def Privacy.add_item(key, value)
      @hash ||= {}
      @hash[key] = value
    end

    def Privacy.const_missing(key)
      @hash[key]
    end

    def Privacy.each
      @hash.each {|key, value| yield(key, value)}
    end

    Privacy.add_item :PUBLIC, 1 # Everyone can view your story, but editing privileges are normal
    Privacy.add_item :CONTRIBUTORS, 2 # Only Contributors can view the story
    Privacy.add_item :OPEN, 3 # Anyone can add Paragraphs and Comments
  end

  belongs_to :user
  attr_accessible :subtitle, :title, :genre1, :genre2, :public, :content, :draft, :privacy, :banner
  has_many :scenes, :order => :position
  has_many :comments
  has_many :story_roles
  has_many :contributors, :through => :story_roles, :source => :user
  has_many :cowriters, :through => :story_roles, :source => :user, :conditions => ['role = ?', 'cowriter']
  has_many :moderators, :through => :story_roles, :source => :user, :conditions => ['role = ?', 'moderator']
  has_attached_file :banner
  has_paper_trail :only => [:title, :subtitle]
  validates :title, :presence => true
  validates_attachment_content_type :banner, :content_type => /\Aimage\/.*\Z/

  scope :by_flagged, lambda { |flag|
    if flag
      joins('LEFT OUTER JOIN story_flags ON stories.id = story_flags.story_id').select('stories.*, count(story_flags.id) as flags_num').group("stories.id").having("flags_num > 0")
    else
      joins('LEFT OUTER JOIN story_flags ON stories.id = story_flags.story_id').select('stories.*, count(story_flags.id) as flags_num').group("stories.id").having("flags_num = 0")
    end
  }

  extend FriendlyId
  friendly_id :title, use: :slugged

  # Returns all story records that have been published (are not drafts)
  def self.find_published(options)
    Story.by_flagged(false).where(:draft => false).with_scope do
      if options.kind_of?(Array) #presemably a list of story ids?
        if (options.length == 1)
          story = find_by_id(options)
          if (!story.nil?)
            [].push(story)
          else
            []
          end
        else
          find(options)
        end
      else
        find(:all, options)
      end
    end
  end

  # Returns all story records that are drafts (haven't been published)
  def self.find_drafts(options)
    Story.by_flagged(false).where(:draft => true).with_scope do
      if options.kind_of?(Array) #presemably a list of story ids?
        find(options)
      else
        find(:all, options)
      end
    end
  end

  # Returns true if the story is still in draft mode (has not been published
  # yet).
  def is_draft?
    self.draft
  end

  # Returns true if the entire story is settled (all scenes
  # have a declared winner or only consist of one paragraph)
  def settled?
    self.scenes.inject {|res, s| res && s.settled?}
  end

  # Returns an array of Paragraph objects that correspond to
  # the top liked or winning paragraphs for each scene in the story.
  def final_draft
    paragraphs = []
    self.scenes.each do |s|
      paragraphs.push(s.ordered_paragraphs.first)
    end
    paragraphs
  end

  # Returns the word count for the final draft version
  # of the story.
  def word_count
    count = 0
    self.final_draft.each do |p|
      if !p.nil?
        count += p.word_count
      end
    end
    count
  end

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
          # need to explicitly destroy paragraphs/comments 
          # so paper_records the destroy event
          Scene.find(scene_id).comments.destroy_all
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
          scene_obj.prompt = scene['prompt']
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

  # Returns true if the story was flagged by anyone.
  def flagged?
    !self.flags.empty?
  end

  def flags
    StoryFlag.where(:story_id => self.id)
  end

  # Returns the votes it has gotten for a certain prompt
  def prompt_votes(prompt)
    PromptVote.where(:prompt_id => prompt.id, :story_id => self.id)
  end
end
