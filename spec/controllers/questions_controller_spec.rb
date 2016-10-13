require 'rails_helper'

describe QuestionsController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:another_question) { create(:question, user: other_user) }
  let(:answers) { create_list(:answer, 2, question: question, user: user) }
  let(:vote_up_request) { proc { patch :vote_up, id: question, format: :json } }
  let(:vote_down_request) { proc { patch :vote_down, id: question, format: :json } }
  let(:cancel_vote_request) { proc { delete :cancel_vote, id: question, format: :json } }

  before { sign_in(user) }

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
    let(:questions_array) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions_array)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns the answers of question to @answers' do
      expect(assigns(:answers)).to eq question.answers
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    let(:create_request) { proc { |q| post :create, question: attributes_for(q) } }

    context 'with valid object' do
      it_behaves_like "count changing", Question

      it 'redirects to show this question view' do
        create_request.call(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid object' do
      it_behaves_like "count not changing", Question
      it_behaves_like 'rendering template for invalid', :invalid_question, :new
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_request) { proc { |q| delete :destroy, id: q } }

    it 'deletes the question of the user' do
      question
      expect { delete_request.call(question) }.to change(Question, :count).by(-1)
    end

    it 'not deletes the question of the other user' do
      another_question
      expect { delete_request.call(another_question) }.to_not change(Question, :count)
    end
  end

  describe 'PATCH #update' do
    let(:patch_request) do
      proc { |attr, q = question| patch :update, id: q, question: attr, format: :js }
    end
    let(:other_subject) { another_question }
    subject { question }

    it_behaves_like 'patchable', :question, title: 'New title', body: 'New body'
  end

  subject { question }
  it_behaves_like 'votable'
end
