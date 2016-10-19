require 'rails_helper'

describe NewAnswerJob do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question, body: 'New answer') }
  let!(:subscription1) { create(:subscription, user: create(:user), question: question) }
  let!(:subscription2) { create(:subscription, user: create(:user), question: question) }

  it 'sends a new answer to subscribers of question' do
    question.subscribers.each do |user|
      expect(QuestionMailer).to receive(:new_answer).with(user, instance_of(Answer)).and_call_original
    end
    NewAnswerJob.perform_now(answer)
  end
end
