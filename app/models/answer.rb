class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user  

  validates :body, presence: true, length: { maximum: 5000 }
  validates :question_id, presence: true
  validates :user_id, presence: true

  default_scope { order(bestflag: :desc) }

  def set_best_answer
    transaction do
      question.answers.update_all(bestflag: false)
      update!(bestflag: true)
    end
  end
end
