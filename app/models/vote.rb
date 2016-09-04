class Vote < ActiveRecord::Base
  validates :vote, presence: true, inclusion: { in: [-1, 1] }
  belongs_to :votable, polymorphic: true
  belongs_to :user
end
