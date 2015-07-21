require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:f_user) { create(:user) }
  let!(:f_question) { create(:question, user: f_user) }
  let!(:f_answer) { create(:answer, question: f_question, user: f_user) }
  before { sign_in(f_user) }

  describe 'GET #new' do
    before { get :new, question_id: f_question, user_id: f_user }

    it 'creates a new Answer object' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders a new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid object' do
      it 'saves new answer in database' do
        expect { post :create, answer: attributes_for(:answer), question_id: f_question, user_id: f_user }.to change(f_question.answers, :count).by(1)
      end

      it 'redirects to show question page' do
        post :create, answer: attributes_for(:answer), question_id: f_question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid object' do
      it 'does no save the answer' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: f_question, user_id: f_user }.to_not change(Answer, :count)
      end

      it 're-renders a new template' do
        post :create, answer: attributes_for(:invalid_answer), question_id: f_question
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the answer of the user' do
      expect { delete :destroy, id: f_answer, question_id: f_question, user_id: f_user }.to change(f_question.answers, :count).by(-1)
    end

    let!(:f2_user) { create(:user) }
    let!(:f2_question) { create(:question, user: f_user) }
    let!(:f2_answer) { create(:answer, question: f2_question, user: f2_user) }
    it 'not deletes the answer of the other user' do
      expect { delete :destroy, id: f2_answer, question_id: f2_question, user_id: f2_user }.to_not change(f2_question.answers, :count)
    end
  end
end
