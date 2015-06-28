require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:f_question) { create(:question) }
  let!(:f_answer) { create(:answer, question: f_question) }

  describe 'GET #new' do
    before { get :new, question_id: f_question }

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
        expect { post :create, answer: attributes_for(:answer), question_id: f_question }.to change(f_question.answers, :count).by(1)
      end

      it 'redirects to show question page' do
        post :create, answer: attributes_for(:answer), question_id: f_question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid object' do
      it 'does no save the answer' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: f_question }.to_not change(Answer, :count)
      end

      it 're-renders a new template' do
        post :create, answer: attributes_for(:invalid_answer), question_id: f_question
        expect(response).to render_template :new
      end
    end
  end
end
