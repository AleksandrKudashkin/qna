require 'rails_helper'

describe 'Answers API' do
  def without_token_test(path)
    get path
    expect(response.status).to eq 401
  end

  def with_invalid_token_test(path)
    get path, access_token: '1234'
    expect(response.status).to eq 401
  end

  describe 'GET api/v1/answers/:id' do
    let(:question) { create(:question, user: create(:user)) }
    let!(:answer) { create(:answer, user: create(:user), question: question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        without_token_test("/api/v1/answers/#{answer.id}")
      end
      it 'returns 401 status if access_token is invalid' do
        with_invalid_token_test("/api/v1/answers/#{answer.id}")
      end
    end

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

      before do
        get "/api/v1/answers/#{answer.id}", access_token: access_token.token
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at user_id).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(
            answer.send(attr.to_sym).to_json
          ).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(2).at_path("answer/comments")
        end

        %w(id body created_at updated_at user_id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(
              comment.send(attr.to_sym).to_json
            ).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(2).at_path("answer/attachments")
        end

        %w(id file_url created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(
              attachment.send(attr.to_sym).to_json
            ).at_path("answer/attachments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let!(:question) { create(:question, user: create(:user)) }

    context 'unauthorized' do
      it 'returns 401 status' do
        post "/api/v1/questions/#{question.id}/answers",
             question: question,
             answer: attributes_for(:answer)
        expect(response.status).to eq 401
      end

      it 'returns 401 with invalid token' do
        post "/api/v1/questions/#{question.id}/answers",
             question: question,
             answer: attributes_for(:answer),
             access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:create_request) do
        proc do |a|
          post "/api/v1/questions/#{question.id}/answers",
               question: question,
               answer: attributes_for(a),
               access_token: access_token.token
        end
      end

      context 'with valid object' do
        it 'returns 201 status' do
          create_request.call(:answer)
          expect(response.status).to eq 201
        end

        it 'saves the new question in the database' do
          expect { create_request.call(:answer) }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid object' do
        it 'returns 422 status' do
          create_request.call(:invalid_answer)
          expect(response.status).to eq 422
        end

        it 'does not save the question' do
          expect { create_request.call(:invalid_answer) }.to_not change(question.answers, :count)
        end
      end
    end
  end
end
