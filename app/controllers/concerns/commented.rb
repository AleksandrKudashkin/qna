module Commented
  extend ActiveSupport::Concern

  included do
    before_action :load_commentable, only: :add_comment
  end

  def add_comment
    @comment = @commentable.comments.new(commentable_params)
    if @comment.save
      channel = "/#{controller_name.pluralize.downcase}/#{@commentable.id}/comments"
      PrivatePub.publish_to channel, comment: @comment.to_json
      respond_to_json_comment
    else 
      respond_to_json_with_errors_comment
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_commentable
    @commentable = model_klass.find(params[:id])
  end

  def commentable_params
    params.require(:comment).permit(:body)
  end

  def respond_to_json_comment
    respond_to do |format|
      format.json { render json: { comment: @comment.body } }
    end
  end

  def respond_to_json_with_errors_comment
    respond_to do |format|
      format.json { render json: { error: @comment.errors.full_messages.join(", ") } }
    end
  end
end
