require 'rails_helper'

describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }  

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe '#voted_for?' do
    let(:question_vote) { create(:question_vote, votable_id: question.id, user: other_user) }
    let(:answer_vote) { create(:answer_vote, votable_id: answer.id, user: other_user) }

    it 'should return true if voted for a question' do
      question_vote
      expect(other_user.voted_for?(question)).to be_truthy
    end

    it 'should return true if voted for an answer' do
      answer_vote
      expect(other_user.voted_for?(answer)).to be_truthy
    end

    it 'should return false if not voted for a question' do
      expect(user.voted_for?(question)).to be_falsy
    end

    it 'should return false if not voted for an answer' do
      expect(user.voted_for?(answer)).to be_falsy
    end
  end

  describe '#author_of?' do
    it 'should return true if author of the question' do
      expect(user.author_of?(question)).to be true
    end

    it 'should return false if not author of the question' do
      expect(other_user.author_of?(question)).to be false
    end

    it 'should return true if author of the answer' do
      expect(user.author_of?(answer)).to be true
    end
    it 'should return false if not author of the answer' do
      expect(other_user.author_of?(answer)).to be false
    end
  end
end
