require 'rails_helper'

describe AnswersController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:question) { create(:question, user: user) }

  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:other_answer) { create(:answer, question: question, user: other_user, bestflag: true) }  

  before { sign_in(user) }

  describe 'POST #create' do
    context 'with valid object' do
      it 'saves new answer in database' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create js answer template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid object' do
      it 'does not save the answer' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'renders a create js answer template' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the answer of the user' do
      expect { delete :destroy, id: answer, question_id: question, format: :js }.to change(question.answers, :count).by(-1)
    end

    
    it 'not deletes the answer of the other user' do
      expect { delete :destroy, id: other_answer, question_id: question, format: :js }.to_not change(question.answers, :count)
    end
  end

  describe 'PATCH #update' do
    def do_patch(attrs)
      patch :update, id: answer, question_id: question, answer: attrs, format: :js
    end

    it 'assigns the requested answer to @answer' do
      do_patch(attributes_for(:answer))
      expect(assigns(:answer)).to eq answer     
    end

    it 'assigns the question of requested answer to @question' do
      do_patch(attributes_for(:answer))
      expect(assigns(:question)).to eq question     
    end

    it 'changes answer attributes' do
      do_patch(body: 'New body')
      answer.reload
      expect(answer.body).to eq 'New body'
    end

    it 'renders update template' do
      do_patch(attributes_for(:answer))
      expect(response).to render_template :update
    end

    it 'not edites the answer of the other user' do
      patch :update, id: other_answer, question_id: question, answer: { body: 'New body' }, format: :js
      other_answer.reload
      expect(other_answer.body).to_not eq 'New body'
    end
  end

  describe 'PATCH#vote_up and PATCH#vote_down' do
    
    context 'author of the answer' do
      before { sign_in(user) }

      it 'should not add new vote to answer, vote up' do
        patch :vote_up, id: answer, question_id: question, format: :json
        expect { patch :vote_up, id: answer, question_id: question, format: :json }.to_not change(answer.votes, :count)
      end

      it 'should not add new vote to answer, vote down' do
        patch :vote_down, id: answer, question_id: question, format: :json
        expect { patch :vote_down, id: answer, question_id: question, format: :json }.to_not change(answer.votes, :count)
      end
    end
    
    context 'other_user' do
      before { sign_in(other_user) }

      it 'should add new vote to answer, vote up' do
        expect { patch :vote_up, id: answer, question_id: question, format: :json }.to change(answer.votes, :count).by(1)
      end

      it 'should add new vote to answer, vote down' do
        expect { patch :vote_down, id: answer, question_id: question, format: :json }.to change(answer.votes, :count).by(1)
      end

      it 'should not add new vote to answer if this user has already voted, vote up' do
         patch :vote_up, id: answer, question_id: question, format: :json
         expect { patch :vote_up, id: answer, question_id: question, format: :json }.to_not change(answer.votes, :count)
      end

      it 'should not add new vote to answer if this user has already voted, vote down' do
        patch :vote_down, id: answer, question_id: question, format: :json
        expect { patch :vote_down, id: answer, question_id: question, format: :json }.to_not change(answer.votes, :count)
      end
    end
  end
  
  describe 'DELETE#cancel_vote' do
    
    before { sign_in(other_user) }
    
    it 'should delete vote from question when already voted' do
      patch :vote_up, id: answer, question_id: question, format: :json
      expect { delete :cancel_vote, id: answer, question_id: question, format: :json }.to change(answer.votes, :count).by(-1)
    end
  end

  describe 'PATCH #best' do
    it 'allows only one best answer' do
      patch :best, id: answer, question_id: question, format: :js
      
      answer.reload
      other_answer.reload

      expect(other_answer.bestflag).to eq false
      expect(answer.bestflag).to eq true
    end
  end
end
