require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Attachment }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for author' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:other_answer) { create(:answer, question: question, user: other) }
    let(:third_answer) { create(:answer, question: other_question, user: other) }
    let(:attachment) { create(:attachment, attachable: question) }
    let(:other_attachment) { create(:attachment, attachable: other_question) }
    let(:question_vote) { create(:vote, votable: other_question, user: user) }
    let(:answer_vote) { create(:vote, votable: other_answer, user: user) }
    let(:other_vote) { create(:vote, votable: question, user: other) }

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Attachment }
    it { should be_able_to :read, Comment }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Attachment.new(attachable: question) }
    it { should_not be_able_to :create, Attachment.new(attachable: other_question) }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }
    it { should be_able_to :destroy, attachment }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }
    it { should_not be_able_to :destroy, other_attachment }

    it { should be_able_to :best, answer }
    it { should be_able_to :best, other_answer }
    it { should_not be_able_to :best, third_answer }

    it { should be_able_to :vote_up, other_question }
    it { should_not be_able_to :vote_up, question }
    it { should be_able_to :vote_down, other_answer }
    it { should_not be_able_to :vote_down, answer }

    it { should_not be_able_to :subscribe, question }
    it { should be_able_to :subscribe, other_question }
    it { should be_able_to :unsubscribe, question }
    it { should_not be_able_to :unsubscribe, other_question }

    it 'should be able to cancel vote on question' do
      question_vote
      should be_able_to :cancel_vote, other_question
    end

    it 'should be able to cancel vote on answer' do
      answer_vote
      should be_able_to :cancel_vote, other_answer
    end

    it 'should not be able to cancel other vote' do
      other_vote
      should_not be_able_to :cancel_vote, question
    end
  end
end
