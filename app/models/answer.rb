class Answer < ActiveRecord::Base
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user
  has_many :attachments, dependent: :destroy, as: :attachable

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true, length: { maximum: 5000 }
  validates :question_id, presence: true
  validates :user_id, presence: true

  default_scope { order(bestflag: :desc) }
  default_scope { order(created_at: 'ASC') }

  after_create :notify_subscribers_of_question

  def set_best
    transaction do
      question.answers.update_all(bestflag: false)
      update!(bestflag: true)
    end
  end

  private

  def notify_subscribers_of_question
    NewAnswerJob.perform_later(self)
  end
end
