require 'rails_helper'

describe Answer do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:body).is_at_most(5000) }
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 3, question: question, user: user) }

  context 'with no best answers' do
    it 'sets the best answer' do
      @answer = answers.sample
      @answer.set_best
      expect(@answer.bestflag).to eq true
    end
  end

  context 'with the best answer' do
    let!(:best_answer) { create(:answer, question: question, user: user, bestflag: true) }

    it 'sets change the bestflag from old to new answer' do
      @answer = answers.sample
      @answer.set_best

      best_answer.reload

      expect(@answer.bestflag).to eq true
      expect(best_answer.bestflag).to eq false
      expect(question.answers.where('bestflag = true').count).to eq 1
    end
  end
end
