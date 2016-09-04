require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of :vote }
  it { should validate_inclusion_of(:vote).in_array([-1, 1]) }
end
