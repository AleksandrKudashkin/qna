shared_examples_for "Having list of" do |objects, size, path|
  it "includes #{size} of #{objects}" do
    expect(response.body).to have_json_size(size).at_path(path + objects)
  end
end
