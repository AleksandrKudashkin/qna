shared_examples_for "count changing" do |klass|
  it "saves the new #{klass.to_s.downcase} in the database" do
    expect { create_request.call(klass.to_s.downcase.to_sym) }.to change(klass, :count).by(1)
  end
end

shared_examples_for "count not changing" do |klass|
  it "does not save #{klass.to_s.downcase} in the database" do
    expect do
      create_request.call("invalid_#{klass.to_s.downcase}".to_sym)
    end.to_not change(klass, :count)
  end
end
