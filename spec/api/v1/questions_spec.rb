require 'rails_helper'

describe 'Questions API' do
  def without_token_test(path)
    get path
    expect(response.status).to eq 401
  end

  def with_invalid_token_test(path)
    get path, access_token: '1234'
    expect(response.status).to eq 401
  end

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        without_token_test('/api/v1/questions')
      end
      it 'returns 401 status if access_token is invalid' do
        with_invalid_token_test('/api/v1/questions')
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 3, user: create(:user)) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question, user: create(:user)) }

      before { get '/api/v1/questions', access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(3).at_path("questions")
      end

      %w(id title body created_at updated_at user_id).each do |attr|
        it "question object contains #{attr}" do
          question = questions.first
          expect(response.body).to be_json_eql(
            question.send(attr.to_sym).to_json
          ).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(
          question.title.truncate(10).to_json
        ).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at user_id bestflag).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(
              answer.send(attr.to_sym).to_json
            ).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET api/v1/questions/:id' do
    let!(:question) { create(:question, user: create(:user)) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        without_token_test("/api/v1/questions/#{question.id}")
      end
      it 'returns 401 status if access_token is invalid' do
        with_invalid_token_test("/api/v1/questions/#{question.id}")
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:old_comment) do
        create(:comment,
               user: create(:user),
               commentable: question,
               created_at: 2.days.ago)
      end
      let!(:comment) { create(:comment, user: create(:user), commentable: question) }
      let!(:attachment2) { create(:attachment2, attachable: question, created_at: 2.days.ago) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before do
        get "/api/v1/questions/#{question.id}", access_token: access_token.token
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at user_id).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(
            question.send(attr.to_sym).to_json
          ).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path("question/comments")
        end

        %w(id body created_at updated_at user_id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(
              comment.send(attr.to_sym).to_json
            ).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path("question/attachments")
        end

        %w(id file_url created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(
              attachment.send(attr.to_sym).to_json
            ).at_path("question/attachments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET api/v1/questions/:id/answers' do
    let!(:question) { create(:question, user: create(:user)) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        without_token_test("/api/v1/questions/#{question.id}/answers")
      end
      it 'returns 401 status if access_token is invalid' do
        with_invalid_token_test("/api/v1/questions/#{question.id}/answers")
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, question: question, user: create(:user)) }
      let!(:old_answer) do
        create(:answer, question: question, created_at: 2.days.ago, user: create(:user))
      end

      before do
        get "/api/v1/questions/#{question.id}/answers", access_token: access_token.token
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at user_id bestflag).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(
            answer.send(attr.to_sym).to_json
          ).at_path("answers/0/#{attr}")
        end
      end

      it 'included in question object' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end
    end
  end

  describe 'POST /api/v1/questions' do
    context 'unauthorized' do
      it 'returns 401 status' do
        post '/api/v1/questions', question: attributes_for(:question)
        expect(response.status).to eq 401
      end

      it 'returns 401 with invalid token' do
        post '/api/v1/questions', question: attributes_for(:question), access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:create_request) do
        proc do |q|
          post '/api/v1/questions', question: attributes_for(q), access_token: access_token.token
        end
      end

      context 'with valid object' do
        it 'returns 201 status' do
          create_request.call(:question)
          expect(response.status).to eq 201
        end

        it 'saves the new question in the database' do
          expect { create_request.call(:question) }.to change(Question, :count).by(1)
        end
      end

      context 'with invalid object' do
        it 'returns 422 status' do
          create_request.call(:invalid_question)
          expect(response.status).to eq 422
        end

        it 'does not save the question' do
          expect { create_request.call(:invalid_question) }.to_not change(Question, :count)
        end
      end
    end
  end
end
