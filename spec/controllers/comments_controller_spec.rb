require 'rails_helper'

describe CommentsController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:question_comment) { create(:comment, commentable: question) }
  let(:answer_comment) { create(:comment, commentable: answer) }

  describe 'POST#create' do
    before { sign_in(user) }

    context "for question" do
      it 'should add a new comment to question' do
        expect do
          post :create,
               question_id: question,
               commentable: 'questions',
               comment: { body: 'New comment' },
               format: :json
        end.to change(question.comments, :count).by(1)
      end

      it 'should bind a comment to a user' do
        expect do
          post :create,
               question_id: question,
               commentable: 'questions',
               comment: { body: 'New comment' },
               format: :json
        end.to change(user.comments, :count).by(1)
      end

      it 'should not add an invalid comment to question' do
        expect do
          post :create,
               question_id: question,
               commentable: 'questions',
               comment: { body: 't' },
               format: :json
        end.not_to change(question.comments, :count)
      end
    end

    context "for answer" do
      it 'should add a new comment to answer' do
        expect do
          post :create,
               answer_id: answer,
               commentable: 'answers',
               comment: { body: 'New comment' },
               format: :json
        end.to change(answer.comments, :count).by(1)
      end

      it 'should bind a comment to a user' do
        expect do
          post :create,
               answer_id: answer,
               commentable: 'answers',
               comment: { body: 'New comment' },
               format: :json
        end.to change(user.comments, :count).by(1)
      end

      it 'should not add an invalid comment to question' do
        expect do
          post :create,
               answer_id: answer,
               commentable: 'answers',
               comment: { body: 't' },
               format: :json
        end.not_to change(answer.comments, :count)
      end
    end
  end
end
