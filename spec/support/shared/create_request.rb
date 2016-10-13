shared_examples_for "a create response" do |object, status|
  it "returns #{status} status" do
    create_request.call(object.to_sym)
    expect(response.status).to eq status
  end
end
