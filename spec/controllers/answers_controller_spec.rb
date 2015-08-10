require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:f_user) { create(:user) }
  let!(:f_question) { create(:question, user: f_user) }
  let!(:f_answer) { create(:answer, question: f_question, user: f_user) }
  before { sign_in(f_user) }

  describe 'POST #create' do
    context 'with valid object' do
      it 'saves new answer in database' do
        expect { post :create, answer: attributes_for(:answer), question_id: f_question, format: :js }.to change(f_question.answers, :count).by(1)
      end

      it 'renders create js answer template' do
        post :create, answer: attributes_for(:answer), question_id: f_question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid object' do
      it 'does no save the answer' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: f_question, format: :js }.to_not change(Answer, :count)
      end

      it 'renders a create js answer template' do
        post :create, answer: attributes_for(:invalid_answer), question_id: f_question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the answer of the user' do
      expect { delete :destroy, id: f_answer, question_id: f_question, format: :js }.to change(f_question.answers, :count).by(-1)
    end

    let!(:f2_user) { create(:user) }
    let!(:f2_question) { create(:question, user: f_user) }
    let!(:f2_answer) { create(:answer, question: f2_question, user: f2_user) }
    it 'not deletes the answer of the other user' do
      expect { delete :destroy, id: f2_answer, question_id: f2_question }.to_not change(f2_question.answers, :count)
    end
  end

  describe 'PATCH #update' do
    it 'assigns the requested answer to @answer' do
      patch :update, id: f_answer, question_id: f_question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq f_answer     
    end

    it 'assigns the question of requested answer to @question' do
      patch :update, id: f_answer, question_id: f_question, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq f_question     
    end

    it 'changes answer attributes' do
      patch :update, id: f_answer, question_id: f_question, answer: { body: 'New body' }, format: :js
      f_answer.reload
      expect(f_answer.body).to eq 'New body'
    end

    it 'renders update template' do
      patch :update, id: f_answer, question_id: f_question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end
end
