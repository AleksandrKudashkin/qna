require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  def without_token_test(path)
    get path, format: :json
    expect(response.status).to eq 401
  end

  def with_invalid_token_test(path)
    get path, format: :json, access_token: '1234'
    expect(response.status).to eq 401
  end

  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        without_token_test('/api/v1/profiles/me')
      end
      it 'returns 401 status if access_token is invalid' do
        with_invalid_token_test('/api/v1/profiles/me')
      end
    end

    context 'authorized' do
      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email updated_at created_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /profiles' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        without_token_test('/api/v1/profiles')
      end

      it 'returns 401 status if access_token is invalid' do
        with_invalid_token_test('/api/v1/profiles')
      end
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it "contains list of users" do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it 'does not contain current user' do
        expect(response.body).to_not include_json(me.to_json)
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          users.each_with_index do |user, index|
            expect(response.body).to be_json_eql(
              user.send(attr.to_sym).to_json
            )
              .at_path("#{index}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          users.each_with_index do |_user, index|
            expect(response.body).to_not have_json_path("#{index}/#{attr}")
          end
        end
      end
    end
  end
end
