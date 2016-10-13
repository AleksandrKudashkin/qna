require 'rails_helper'

describe Question do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(150) }
  it { should validate_length_of(:body).is_at_most(3000) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should belong_to :user }
  it { should accept_nested_attributes_for :attachments }
end
