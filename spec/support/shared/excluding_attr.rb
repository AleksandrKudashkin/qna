shared_examples_for "Excluding attributes" do |attrs|
  attrs.each do |attr|
    it "does not contain #{attr}" do
      expect(response.body).to_not have_json_path(attr)
    end
  end
end
