class User < ActiveRecord::Base
  acts_as_voter
  acts_as_reader
  has_settings

  validates_presence_of :name
  validates_presence_of :birthday, :on => :create
  validate :birthday_older_than_13

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid, :name, :birthday

  attr_accessible :avatar
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :tiny => "31x31>" }
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  user = User.where(:provider => auth.provider, :uid => auth.uid).first
  unless user
    user = User.create(name:auth.extra.raw_info.name, provider:auth.provider, uid:auth.uid,
      email:auth.info.email, password:Devise.friendly_token[0,20])
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  # Outputs the role a given user has for a given story.
  def self.role_for_story(user, story_id)
    if user.nil?
      return "loggedout"
    end
    
    @story = Story.find(story_id)
    @story_roles = StoryRole.find(:first, :conditions => {:user_id => user.id, :story_id => story_id})
    
    if @story.user.id == user.id
      "owner"
    elsif !@story_roles.nil?
      @story_roles.role
    else
      "reader"
    end
  end

  def stories
    Story.find_published(:conditions => {:user_id => self.id})
  end

  def mod_stories
    @story_roles = StoryRole.find(:all, :conditions => {:user_id => self.id, :role => "moderator" })
    Story.find_published(:conditions => ["stories.id IN (?)", @story_roles.map { |sr| sr.story_id }])
  end

  def cowrite_stories
    @story_roles = StoryRole.find(:all, :conditions => {:user_id => self.id, :role => "cowriter" })
    Story.find_published(:conditions => ["stories.id IN (?)", @story_roles.map { |sr| sr.story_id }])
  end

  def contribute_stories
    @story_roles = StoryRole.find(:all, :conditions => {:user_id => self.id, :role => "contributor" })
    Story.find_published(:conditions => ["stories.id IN (?)", @story_roles.map { |sr| sr.story_id }])
  end

  def flagged_stories
    Story.by_flagged(true).where(:user_id => self.id)
  end

  # Draft stories the user owns or is a moderator/cowriter for
  def draft_stories    
    @stories = Story.find_drafts(:conditions => {:user_id => self.id})
    @story_roles = StoryRole.find(:all, :conditions => {:user_id => self.id, :role => ["moderator", "cowriter"] })
    @mod_draft_stories = Story.find_drafts(:conditions => ["stories.id IN (?)", @story_roles.map { |sr| sr.story_id }])
    if (!@mod_draft_stories.nil?)
      @stories += @mod_draft_stories
    end
    @stories
  end

  # A custom validation to check that all users are 13 or older.
  def birthday_older_than_13
    now = Time.now.utc.to_date
    if !birthday.nil?
      age = now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
    end
    errors.add(:birthday, "must show that you are 13 or older.") if birthday.nil? || age < 13
  end

  # Returns true if user is an owner or contributor to a story
  def is_contributor?(story)
    User.role_for_story(self, story.id) == "loggedout" || User.role_for_story(self, story.id) == "reader"
  end

  def is_guest?
    self.name == "guest"
  end

  # Users can flag stories
  # Takes a story model and a string for reason.
  def flag!(story, reason)
    @story_flag = StoryFlag.new(:user_id => self.id, :story_id => story.id, :reason => reason)
    @story_flag.save
  end

  def unflag!(story)
    @flags = StoryFlag.where(:story_id => story.id)
    @flags.each do |f|
      f.destroy
    end
  end

  def flags
    StoryFlag.where(:user_id => self.id)
  end
end
