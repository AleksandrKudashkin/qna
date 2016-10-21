class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user_abilities
    else
      guest_abilities
    end
  end

  protected

  def guest_abilities
    can :read, [Question, Answer, Comment, Attachment]
    can :search, Search
  end

  def user_abilities
    guest_abilities

    alias_action :create, :read, :update, :destroy, to: :crud
    can :crud, [Question, Answer, Comment], user_id: user.id
    can :create, Attachment, attachable: { user_id: user.id }
    can :read, User
    can :me, User, user_id: user.id
    can :subscribe, Question do |q|
      !user.subscribed_to?(q)
    end
    can :unsubscribe, Question do |q|
      user.subscribed_to?(q)
    end

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end

    can :best, Answer, question: { user_id: user.id }

    can :vote_up, [Question, Answer] do |votable|
      can_vote?(votable)
    end

    can :vote_down, [Question, Answer] do |votable|
      can_vote?(votable)
    end

    can :cancel_vote, [Question, Answer] do |votable|
      user.voted_for?(votable)
    end
  end

  def can_vote?(votable)
    !(user.author_of?(votable) || user.voted_for?(votable))
  end
end
