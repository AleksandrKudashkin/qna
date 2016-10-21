require 'rails_helper'

describe Search do
  it 'should invoke Thinking Sphinx for All' do
    expect(ThinkingSphinx).to receive(:search).with(ThinkingSphinx::Query.escape('@test.com'))
    Search.search('@test.com', 'All')
  end

  %w(Question Answer Comment User).each do |klass|
    it "should invoke ThinkingSphing for #{klass} class" do
      expect(klass.constantize).to receive(:search).with(ThinkingSphinx::Query.escape('Lorem@'))
      Search.search('Lorem@', klass)
    end
  end

  it 'should return empty array if wrong filter' do
    expect(Search.search('Lorem Ipsum', 'asdf')).to be_empty
  end
end
