class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
  validates :title, length: { minimum: 5, maximum: 150 }
  validates :body, length: { maximum: 3000 }
  validates :user_id, presence: true
end
