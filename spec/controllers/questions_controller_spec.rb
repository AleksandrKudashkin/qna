require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:f_user) { create(:user) }
  
  before { sign_in(f_user) }

  describe 'GET #new' do
  
    before { get :new }

    it 'assigns a new Question object' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders a form for new question' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #index' do
    let(:questions_array) { create_list(:question, 3, user: f_user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions_array)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let!(:f_question) { create(:question, user: f_user) }
    let!(:answers) { create_list(:answer, 2, question: f_question, user: f_user) }
    before { get :show, id: f_question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq f_question
    end

    it 'assigns the answers of question to @answers' do
      expect(assigns(:answers)).to eq f_question.answers
    end

    it 'creates a new Answer object' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'rendres show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    
    context 'with valid object' do
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show this question view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid object' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders template with form for new question' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:f_question) { create(:question, user: f_user) }
    let!(:f2_user) { create(:user) }
    let!(:f2_question) { create(:question, user: f2_user) }
    it 'deletes the question of the user' do
      expect { delete :destroy, id: f_question }.to change(Question, :count).by(-1)
    end

    it 'not deletes the question of the other user' do
      expect { delete :destroy, id: f2_question }.to_not change(Question, :count)
    end
  end

  describe 'PATCH #update' do
    let!(:f_question) { create(:question, user: f_user) }
    let!(:f2_user) { create(:user) }
    let!(:f2_question) { create(:question, user: f2_user) }
    
    def do_patch(attrs)
      patch :update, id: f_question, question: attrs, format: :js
    end

    it 'assigns the requested question to @question' do
      do_patch(attributes_for(:question))
      expect(assigns(:question)).to eq f_question     
    end

    it 'changes question attributes' do
      do_patch(title: 'New title', body: 'New body')
      f_question.reload
      expect(f_question.title).to eq 'New title'
      expect(f_question.body).to eq 'New body'
    end

    it 'renders update template' do
      do_patch(attributes_for(:question))
      expect(response).to render_template :update
    end

    it 'not edites the answer of the other user' do
      patch :update, id: f2_question, question: { title: 'New title', body: 'New body' }, format: :js
      f2_question.reload
      expect(f2_question.title).to_not eq 'New title'
      expect(f2_question.body).to_not eq 'New body'
    end
  end

end
