require 'rails_helper'

describe AnswersController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:other_answer) { create(:answer, question: question, user: other_user, bestflag: true) }
  let(:vote_up_request) do
    proc { patch :vote_up, id: answer, question_id: question.id, format: :json }
  end
  let(:vote_down_request) do
    proc { patch :vote_down, id: answer, question_id: question.id, format: :json }
  end
  let(:cancel_vote_request) do
    proc { delete :cancel_vote, id: answer, question_id: question.id, format: :json }
  end

  before { sign_in(user) }

  describe 'POST #create' do
    let(:create_request) do
      proc do |a, q = question|
        post :create, answer: attributes_for(a), question_id: q.id, format: :js
      end
    end

    context 'with valid object' do
      it 'saves new answer in database' do
        expect { create_request.call(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'renders create js answer template' do
        create_request.call(:answer)
        expect(response).to render_template :create
      end
    end

    context 'with invalid object' do
      it_behaves_like 'count not changing', Answer
      it_behaves_like 'rendering template for invalid', :invalid_answer, :create
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_request) do
      proc { |a| delete :destroy, id: a, question_id: question.id, format: :js }
    end

    it 'deletes the answer of the user' do
      expect { delete_request.call(answer) }.to change(question.answers, :count).by(-1)
    end

    it 'not deletes the answer of the other user' do
      expect { delete_request.call(other_answer) }.to_not change(question.answers, :count)
    end
  end

  describe 'PATCH #update' do
    let(:patch_request) do
      proc do |attr, a = answer, q = question|
        patch :update, id: a, question_id: q.id, answer: attr, format: :js
      end
    end
    let(:other_subject) { other_answer }
    subject { answer }

    it_behaves_like 'patchable', :answer, body: 'New body'

    it 'assigns the question of requested answer to @question' do
      patch_request.call(attributes_for(:answer))
      expect(assigns(:question)).to eq question
    end
  end

  subject { answer }
  it_behaves_like 'votable'

  describe 'PATCH #best' do
    before { patch :best, id: answer.id, format: :js }

    it 'allows only one best answer' do
      answer.reload
      other_answer.reload
      expect(answer.bestflag).to eq true
      expect(other_answer.bestflag).to eq false
    end

    it 'assigns answers with list of answers to a question' do
      expect(assigns(:answers)).to match_array(question.answers)
    end
  end
end
