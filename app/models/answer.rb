class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, presence: true, length: { maximum: 5000 }
  validates :question_id, presence: true
end
