require 'rails_helper'

describe Comment do
  it { should belong_to :commentable }
  it { should belong_to :user }
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(5) }
end
