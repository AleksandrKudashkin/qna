require 'rails_helper'

describe QuestionsController do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:another_question) { create(:question, user: another_user) }
  let(:answers) { create_list(:answer, 2, question: question, user: user) }
  let(:vote_up_request) { proc { patch :vote_up, id: question, format: :json } }
  let(:vote_down_request) { proc { patch :vote_down, id: question, format: :json } }

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
      it 'saves the new question in the database' do
        expect { create_request.call(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show this question view' do
        create_request.call(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid object' do
      it 'does not save the question' do
        expect { create_request.call(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders template with form for new question' do
        create_request.call(:invalid_question)
        expect(response).to render_template :new
      end
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

    it 'assigns the requested question to @question' do
      patch_request.call(attributes_for(:question))
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      patch_request.call(title: 'New title', body: 'New body')
      question.reload
      expect(question.title).to eq 'New title'
      expect(question.body).to eq 'New body'
    end

    it 'renders update template' do
      patch_request.call(attributes_for(:question))
      expect(response).to render_template :update
    end

    it 'not edites the answer of the other user' do
      patch_request.call({ title: 'New title', body: 'New body' }, another_question)
      another_question.reload
      expect(another_question.title).to_not eq 'New title'
      expect(another_question.body).to_not eq 'New body'
    end
  end

  describe 'PATCH#vote_up and PATCH#vote_down' do
    context 'author' do
      it 'should not add new vote to question, vote up' do
        vote_up_request.call
        expect { vote_up_request.call }.to_not change(question.votes, :count)
      end

      it 'should not add new vote to question, vote down' do
        vote_up_request.call
        expect { vote_up_request.call }.to_not change(question.votes, :count)
      end
    end

    context 'other_user' do
      before { sign_in(another_user) }

      it 'should add new vote to question, vote up' do
        expect { vote_up_request.call }.to change(question.votes, :count).by(1)
      end

      it 'should add new vote to question, vote down' do
        expect { vote_down_request.call }.to change(question.votes, :count).by(1)
      end

      it 'should not add new vote to question if this user has already voted, vote up' do
        vote_up_request.call
        expect { vote_up_request.call }.to_not change(question.votes, :count)
      end

      it 'should not add new vote to question if this user has already voted, vote down' do
        vote_up_request.call
        expect { vote_down_request.call }.to_not change(question.votes, :count)
      end
    end
  end

  describe 'DELETE#cancel_vote' do
    before { sign_in(another_user) }

    it 'should delete vote from question' do
      vote_up_request.call
      expect do
        delete :cancel_vote, id: question, format: :json
      end.to change(question.votes, :count).by(-1)
    end
  end
end
