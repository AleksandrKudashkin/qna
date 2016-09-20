require 'rails_helper'

describe AnswersController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:other_answer) { create(:answer, question: question, user: other_user, bestflag: true) }
  let(:vote_up_request) do
    proc { patch :vote_up, id: answer, question_id: question, format: :json }
  end
  let(:vote_down_request) do
    proc { patch :vote_down, id: answer, question_id: question, format: :json }
  end

  before { sign_in(user) }

  describe 'POST #create' do
    let(:create_request) do
      proc do |a, q = question|
        post :create, answer: attributes_for(a), question_id: q, format: :js
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
      it 'does not save the answer' do
        expect { create_request.call(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 'renders a create js answer template' do
        create_request.call(:invalid_answer)
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the answer of the user' do
      answer
      expect do
        delete :destroy, id: answer, question_id: question, format: :js
      end.to change(question.answers, :count).by(-1)
    end

    it 'not deletes the answer of the other user' do
      other_answer
      expect do
        delete :destroy, id: other_answer, question_id: question, format: :js
      end.to_not change(question.answers, :count)
    end
  end

  describe 'PATCH #update' do
    let(:patch_request) do
      proc do |attr, a = answer, q = question|
        patch :update, id: a, question_id: q, answer: attr, format: :js
      end
    end

    it 'assigns the requested answer to @answer' do
      patch_request.call(attributes_for(:answer))
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question of requested answer to @question' do
      patch_request.call(attributes_for(:answer))
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch_request.call(body: 'New body')
      answer.reload
      expect(answer.body).to eq 'New body'
    end

    it 'renders update template' do
      patch_request.call(attributes_for(:answer))
      expect(response).to render_template :update
    end

    it 'not edites the answer of the other user' do
      patch_request.call({ body: 'New body' }, other_answer)
      other_answer.reload
      expect(other_answer.body).to_not eq 'New body'
    end
  end

  describe 'PATCH#vote_up' do
    context 'author of the answer' do
      before { sign_in(user) }

      it 'should not add new vote to answer, vote up' do
        vote_up_request.call
        expect { vote_up_request.call }.to_not change(answer.votes, :count)
      end
    end

    context 'other_user' do
      before { sign_in(other_user) }

      it 'should add new vote to answer, vote up' do
        expect { vote_up_request.call }.to change(answer.votes, :count).by(1)
      end

      it 'should not add new vote to answer if this user has already voted, vote up' do
        vote_up_request.call
        expect { vote_up_request.call }.to_not change(answer.votes, :count)
      end
    end
  end
  describe 'PATCH#vote_down' do
    context 'author of the answer' do
      before { sign_in(user) }

      it 'should not add new vote to answer, vote down' do
        vote_down_request.call
        expect { vote_down_request.call }.to_not change(answer.votes, :count)
      end
    end
    context 'other_user' do
      before { sign_in(other_user) }

      it 'should not add new vote to answer if this user has already voted, vote down' do
        vote_down_request.call
        expect { vote_down_request.call }.to_not change(answer.votes, :count)
      end

      it 'should add new vote to answer, vote down' do
        expect { vote_down_request.call }.to change(answer.votes, :count).by(1)
      end
    end
  end

  describe 'DELETE#cancel_vote' do
    before { sign_in(other_user) }

    it 'should delete vote from question when already voted' do
      patch :vote_up, id: answer, question_id: question, format: :json
      expect do
        delete :cancel_vote, id: answer, question_id: question, format: :json
      end.to change(answer.votes, :count).by(-1)
    end
  end

  describe 'PATCH #best' do
    it 'allows only one best answer' do
      answer
      other_answer

      patch :best, id: answer, question_id: question, format: :js

      answer.reload
      other_answer.reload

      expect(other_answer.bestflag).to eq false
      expect(answer.bestflag).to eq true
    end
  end

  describe 'POST#add_comment' do
    before { sign_in(user) }

    it 'should add a new comment to question' do
      question
      answer
      expect do
        post :add_comment,
             id: answer,
             question_id: question,
             comment: { body: 'New comment' },
             format: :json
      end.to change(answer.comments, :count).by(1)
    end
  end
end
