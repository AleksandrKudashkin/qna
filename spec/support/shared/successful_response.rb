shared_examples_for "Successful response" do
  it 'returns 200 status' do
    expect(response).to be_success
  end
end
