require 'rails_helper'

describe 'Answers API' do
  describe 'GET api/v1/answers/:id' do
    let(:question) { create(:question, user: create(:user)) }
    let!(:answer) { create(:answer, user: create(:user), question: question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:old_comment) do
        create(:comment,
               user: create(:user),
               commentable: answer,
               created_at: 2.days.ago)
      end
      let!(:comment) { create(:comment, user: create(:user), commentable: answer) }
      let!(:attachment2) { create(:attachment2, attachable: answer, created_at: 2.days.ago) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let(:prefix) { 'answer/' }
      subject { answer }

      before do
        get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }
      end

      it_behaves_like "Successful response"
      it_behaves_like "Including attributes", %w(id body created_at updated_at user_id)

      context 'comments' do
        let(:prefix) { 'answer/comments/0/' }
        subject { comment }
        it_behaves_like "Having list of", "comments", 2, 'answer/'
        it_behaves_like "Including attributes", %w(id body created_at updated_at user_id)
      end

      context 'attachments' do
        let(:prefix) { 'answer/attachments/0/' }
        subject { attachment }

        it_behaves_like "Having list of", "attachments", 2, 'answer/'
        it_behaves_like "Including attributes", %w(id file_url created_at updated_at)
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: options
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let!(:question) { create(:question, user: create(:user)) }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:create_request) do
        proc do |a|
          post "/api/v1/questions/#{question.id}/answers",
               params: {
                 question: question,
                 answer: attributes_for(a),
                 access_token: access_token.token
               }
        end
      end

      context 'with valid object' do
        it_behaves_like "a create response", :answer, 201

        it 'saves the new question in the database' do
          expect { create_request.call(:answer) }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid object' do
        it_behaves_like "a create response", :invalid_answer, 422
        it_behaves_like "count not changing", Answer
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers",
           params: { question: question, answer: attributes_for(:answer) }.merge(options)
    end
  end
end
