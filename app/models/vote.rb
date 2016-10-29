class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user
  validates :vote, presence: true, inclusion: { in: [-1, 1] }
end
