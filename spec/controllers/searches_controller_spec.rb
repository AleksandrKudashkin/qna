require 'rails_helper'

describe SearchesController do
  describe "GET #search" do
    let(:request) { get :search, search: { query: 'lorem', filter: 'Question' } }
    it "returns http success" do
      request
      expect(response).to have_http_status(:success)
    end

    it 'should run Search.search' do
      expect(Search).to receive(:search).with('lorem', 'Question')
      request
    end
  end
end
