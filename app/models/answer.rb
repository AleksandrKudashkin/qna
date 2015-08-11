class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user  

  validates :body, presence: true, length: { maximum: 5000 }
  validates :question_id, presence: true
  validates :user_id, presence: true

  default_scope { order(:created_at) }
end
