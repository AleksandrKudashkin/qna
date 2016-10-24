class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_answer, only: [:destroy, :update, :best]
  before_action :find_question, only: [:create, :update, :best]

  respond_to :js

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    return unless current_user.author_of?(@answer)
    @answer.update(answer_params)
    load_answers
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy) if current_user.author_of?(@answer)
  end

  def best
    @answer.set_best if current_user.author_of?(@question)
    load_answers
  end

  private

  def find_question
    @question = if params[:question_id]
                  Question.find(params[:question_id])
                else
                  @answer.question
                end
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def load_answers
    @answers = @question.answers
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
