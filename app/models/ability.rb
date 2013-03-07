class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :current, Story
      can :history, Story
    end

    unless user.id.blank?
        # Owners of stories can...
        can :manage, Story, :user_id => user.id
        can :manage, Scene, :story => { :user_id => user.id }
        can :manage, Paragraph, :scene => { :story => { :user_id => user.id }}
        can :manage, Comment, :scene => { :story => { :user_id => user.id }}
        can :manage, StoryRole, :story => { :user_id => user.id }

        # Trusted users can...
        can :manage, Scene, :story => { :contributors => { :id => user.id } }
        can :manage, Paragraph, :scene => { :story => { :contributors => { :id => user.id } } }

        # Anyone can...
        can :like, Paragraph
        can :history, Story
        can :create, Paragraph
        can :create, Story
        can :create, Scene
        can :manage, Comment, :user_id => user.id
        can :manage, Post, :user_id => user.id
        can :manage, Paragraph, :user_id => user.id

        # Only owners of stories can mark paragraphs as winners
        cannot :winner, Paragraph
        can :winner, Paragraph, :scene => { :story => { :user_id => user.id }}
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
