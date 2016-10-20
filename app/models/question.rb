class Question < ActiveRecord::Base
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable
  belongs_to :user
  has_many :subscribers, through: :subscriptions, source: 'user', foreign_key: 'user_id'

  validates :title, :body, presence: true
  validates :title, length: { minimum: 5, maximum: 150 }
  validates :body, length: { maximum: 3000 }
  validates :user_id, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true

  scope :last24h, -> do
    Question.where(created_at: (Time.zone.now.midnight - 1.day)..Time.zone.now.midnight)
  end

  after_create :subscribe_author

  def subscribe(user)
    subscriptions.create!(user: user)
  end

  def unsubscribe(user)
    Subscription.find_by(user: user).destroy
  end

  private

  def subscribe_author
    subscribe(user)
  end
end
