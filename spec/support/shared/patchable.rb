shared_examples_for 'patchable' do |object, options = {}|
  it "assigns the requested #{object} to @#{object}" do
    patch_request.call(attributes_for(object))
    expect(assigns(object)).to eq subject
  end

  it "changes #{object} attributes" do
    patch_request.call(options)
    subject.reload
    options.each do |key, value|
      expect(subject.send(key.to_sym)).to eq value
    end
  end

  it 'renders update template' do
    patch_request.call(attributes_for(object))
    expect(response).to render_template :update
  end

  it "not edites the #{object} of the other user" do
    patch_request.call(options, other_subject)
    other_subject.reload
    options.each do |key, value|
      expect(other_subject.send(key.to_sym)).to_not eq value
    end
  end
end
