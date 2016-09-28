class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable
  after_action :publish_comment, only: :create

  respond_to :json

  def create
    respond_with(
      @comment = @commentable.comments.create(
        commentable_params.merge(user: current_user)
      ),
      location: polymorphic_path(@commentable)
    )
  end

  private

  def question_id
    @commentable.instance_of?(Question) ? @commentable.id : @commentable.question.id
  end

  def find_commentable
    @commentable = commentable_name.classify.constantize
                                   .find(params["#{commentable_name.singularize}_id".to_sym])
  end

  def commentable_name
    params[:commentable]
  end

  def commentable_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return unless @comment.valid?
    PrivatePub.publish_to("/questions/#{question_id}/comments", comment: @comment.to_json)
  end
end
