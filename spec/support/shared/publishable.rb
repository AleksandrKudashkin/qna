shared_examples_for 'publishable' do
  include ActiveModel::Serializers::JSON

  class IncludedAttribute
    def initialize(body)
      @body = body
    end

    def ==(actual)
      comment = Comment.new
      comment.from_json(actual[:comment].to_s)
      comment.body == @body
    end

    def description
      "comment body includes #{@body}"
    end
  end

  def comment_attr(body)
    IncludedAttribute.new(body)
  end

  it 'should send a publish_to message to a channel' do
    expect(PrivatePub).to receive(:publish_to)
      .with("/questions/#{question.id}/comments",
            comment_attr('New comment'))
    create_request.call(body: 'New comment')
  end

  it 'should not send a publish_to message to a channel if invalid comment' do
    expect(PrivatePub).to_not receive(:publish_to)
      .with("/questions/#{question.id}/comments",
            comment_attr('t'))
    create_request.call(body: 't')
  end
end
