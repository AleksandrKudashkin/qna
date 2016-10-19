class Subscription < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: :question_id }
end
