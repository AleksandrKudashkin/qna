require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 3, user: create(:user)) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question, user: create(:user)) }

      subject { question }
      let(:prefix) { 'questions/0/' }

      before { get '/api/v1/questions', access_token: access_token.token }

      it_behaves_like "Successful response"
      it_behaves_like "Including attributes", %w(id title body created_at updated_at user_id)
      it_behaves_like "Having list of", "questions", 3, ""

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(
          question.title.truncate(10).to_json
        ).at_path("questions/0/short_title")
      end

      context 'answers' do
        subject { answer }
        let(:prefix) { 'questions/0/answers/0/' }

        it_behaves_like "Having list of", "answers", 1, 'questions/0/'
        it_behaves_like "Including attributes", %w(id body created_at updated_at user_id bestflag)
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', options
    end
  end

  describe 'GET api/v1/questions/:id' do
    let!(:question) { create(:question, user: create(:user)) }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:old_comment) do
        create(:comment,
               user: create(:user),
               commentable: question,
               created_at: 2.days.ago)
      end
      let!(:comment) { create(:comment, user: create(:user), commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }
      let!(:attachment2) { create(:attachment2, attachable: question) }

      subject { question }
      let(:prefix) { 'question/' }

      before do
        get "/api/v1/questions/#{question.id}", access_token: access_token.token
      end

      it_behaves_like "Successful response"
      it_behaves_like "Including attributes", %w(id title body created_at updated_at user_id)

      context 'comments' do
        subject { comment }
        let(:prefix) { 'question/comments/0/' }

        it_behaves_like "Having list of", "comments", 2, 'question/'
        it_behaves_like "Including attributes", %w(id body created_at updated_at user_id)
      end

      context 'attachments' do
        subject { attachment2 }
        let(:prefix) { 'question/attachments/0/' }

        it_behaves_like "Having list of", "attachments", 2, 'question/'
        it_behaves_like "Including attributes", %w(id file_url created_at updated_at)
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", options
    end
  end

  describe 'GET api/v1/questions/:id/answers' do
    let!(:question) { create(:question, user: create(:user)) }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, question: question, user: create(:user)) }
      let!(:old_answer) do
        create(:answer, question: question, created_at: 2.days.ago, user: create(:user))
      end

      subject { answer }
      let(:prefix) { 'answers/0/' }

      before do
        get "/api/v1/questions/#{question.id}/answers", access_token: access_token.token
      end

      it_behaves_like "Successful response"
      it_behaves_like "Including attributes", %w(id body created_at updated_at user_id bestflag)
      it_behaves_like "Having list of", "answers", 2, ''
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", options
    end
  end

  describe 'POST /api/v1/questions' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:create_request) do
        proc do |q|
          post '/api/v1/questions', question: attributes_for(q), access_token: access_token.token
        end
      end

      context 'with valid object' do
        it_behaves_like "a create response", :question, 201
        it_behaves_like "count changing", Question
      end

      context 'with invalid object' do
        it_behaves_like "a create response", :invalid_question, 422
        it_behaves_like "count not changing", Question
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', { question: attributes_for(:question) }.merge(options)
    end
  end
end
