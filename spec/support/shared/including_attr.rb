shared_examples_for "Including attributes" do |attrs|
  attrs.each do |attr|
    it "contains #{attr}" do
      expect(response.body).to be_json_eql(subject.send(attr.to_sym).to_json).at_path(prefix + attr)
    end
  end
end
