class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable

  def create
    @comment = @commentable.comments.new(commentable_params.merge(user: current_user))
    if @comment.save
      PrivatePub.publish_to "/questions/#{question_id}/comments", comment: @comment.to_json
      respond_to_json
    else
      respond_to_json_with_errors
    end
  end

  private

  def question_id
    @commentable.instance_of?(Question) ? @commentable.id : @commentable.question.id
  end

  def find_commentable
    @commentable = commentable_name.classify
                                   .constantize.find(params["#{commentable_name.singularize}_id".to_sym])
  end

  def commentable_name
    params[:commentable]
  end

  def commentable_params
    params.require(:comment).permit(:body)
  end

  def respond_to_json
    respond_to do |format|
      format.json { render json: { comment: @comment } }
    end
  end

  def respond_to_json_with_errors
    respond_to do |format|
      format.json { render json: { error: @comment.errors.full_messages.join(", ") } }
    end
  end
end
