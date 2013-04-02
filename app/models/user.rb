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

  def stories
    Story.find(:all, :conditions => {:user_id => self.id})
  end

  # A custom validation to check that all users are 13 or older.
  def birthday_older_than_13
    now = Time.now.utc.to_date
    age = now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
    errors.add(:birthday, "must show that you are 13 or older.") if age < 13
  end
end
