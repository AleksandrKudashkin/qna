require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { get '/api/v1/profiles/me', access_token: access_token.token }
      let(:prefix) { '' }
      subject { me }

      it_behaves_like "Successful response"
      it_behaves_like "Including attributes", %w(id email updated_at created_at)
      it_behaves_like "Excluding attributes", %w(password encrypted_password)
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', options
    end
  end

  describe 'GET /profiles' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }

      before { get '/api/v1/profiles', access_token: access_token.token }

      it_behaves_like "Successful response"

      it "contains list of users" do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it 'does not contain current user' do
        expect(response.body).to_not include_json(me.to_json)
      end

      subject { users.first }
      let(:prefix) { '0/' }
      it_behaves_like "Including attributes", %w(id email created_at updated_at)
      it_behaves_like "Excluding attributes", %w(password encrypted_password)
    end

    def do_request(options = {})
      get '/api/v1/profiles', options
    end
  end
end
