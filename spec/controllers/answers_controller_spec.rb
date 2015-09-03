require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:f_user) { create(:user) }
  let(:f2_user) { create(:user) }

  let!(:f_question) { create(:question, user: f_user) }

  let!(:f_answer) { create(:answer, question: f_question, user: f_user) }
  let!(:f2_answer) { create(:answer, question: f_question, user: f2_user, bestflag: true) }  

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
      it 'does not save the answer' do
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

    
    it 'not deletes the answer of the other user' do
      expect { delete :destroy, id: f2_answer, question_id: f_question, format: :js }.to_not change(f_question.answers, :count)
    end
  end

  describe 'PATCH #update' do
    def do_patch(attrs)
      patch :update, id: f_answer, question_id: f_question, answer: attrs, format: :js
    end

    it 'assigns the requested answer to @answer' do
      do_patch(attributes_for(:answer))
      expect(assigns(:answer)).to eq f_answer     
    end

    it 'assigns the question of requested answer to @question' do
      do_patch(attributes_for(:answer))
      expect(assigns(:question)).to eq f_question     
    end

    it 'changes answer attributes' do
      do_patch(body: 'New body')
      f_answer.reload
      expect(f_answer.body).to eq 'New body'
    end

    it 'renders update template' do
      do_patch(attributes_for(:answer))
      expect(response).to render_template :update
    end

    it 'not edites the answer of the other user' do
      patch :update, id: f2_answer, question_id: f_question, answer: { body: 'New body' }, format: :js
      f2_answer.reload
      expect(f2_answer.body).to_not eq 'New body'
    end
  end

  describe 'PATCH #best' do
    it 'allows only one best answer' do
      patch :best, id: f_answer, question_id: f_question, format: :js
      
      f_answer.reload
      f2_answer.reload

      expect(f2_answer.bestflag).to eq false
      expect(f_answer.bestflag).to eq true
    end
  end
end
