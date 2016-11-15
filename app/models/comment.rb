class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user
  validates :body, presence: true, length: { minimum: 5 }
end
