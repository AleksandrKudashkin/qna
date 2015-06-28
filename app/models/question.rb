class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { minimum: 5, maximum: 150 }
  validates :body, length: { maximum: 3000 }
end
