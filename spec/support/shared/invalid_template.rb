shared_examples_for 'rendering template for invalid' do |object, template|
  it "renders a #{template} template" do
    create_request.call(object)
    expect(response).to render_template template
  end
end
