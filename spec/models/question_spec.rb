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
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '.last24h' do
    let(:old_question) { create(:question, created_at: 2.days.ago, user: create(:user)) }
    let(:questions) { create_list(:question, 2, created_at: 1.day.ago, user: create(:user)) }

    it 'returns a list of questions created in 24 h' do
      expect(Question.last24h).to match_array(questions)
    end

    it 'not returning an old question' do
      expect(Question.last24h).to_not include(old_question)
    end
  end

  describe '#subscribe_author' do
    let(:user) { create(:user) }
    it 'subscribes author to receive notifications' do
      expect do
        Question.create(user: user, title: 'My new title', body: 'My new body')
      end.to change(user.subscriptions, :count).by(1)
    end
  end
end
