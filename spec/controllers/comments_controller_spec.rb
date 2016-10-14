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
      let(:create_request) do
        proc do |comment_attrs|
          post :create,
               question_id: question,
               commentable: 'questions',
               comment: comment_attrs,
               format: :json
        end
      end

      it 'should add a new comment to question' do
        expect do
          create_request.call(body: 'New comment')
        end.to change(question.comments, :count).by(1)
      end

      it 'should bind a comment to a user' do
        expect { create_request.call(body: 'New comment') }.to change(user.comments, :count).by(1)
      end

      it 'should not add an invalid comment to question' do
        expect { create_request.call(body: 't') }.not_to change(question.comments, :count)
      end

      it_behaves_like 'publishable'
    end

    context "for answer" do
      let(:create_request) do
        proc do |comment_attrs|
          post :create,
               answer_id: answer,
               commentable: 'answers',
               comment: comment_attrs,
               format: :json
        end
      end

      it 'should add a new comment to answer' do
        expect { create_request.call(body: 'New comment') }.to change(answer.comments, :count).by(1)
      end

      it 'should bind a comment to a user' do
        expect { create_request.call(body: 'New comment') }.to change(user.comments, :count).by(1)
      end

      it 'should not add an invalid comment to question' do
        expect { create_request.call(body: 't') }.not_to change(answer.comments, :count)
      end

      it_behaves_like 'publishable'
    end
  end
end
