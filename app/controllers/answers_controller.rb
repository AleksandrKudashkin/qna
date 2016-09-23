class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_answer, only: [:destroy, :update, :best]
  before_action :find_question, only: [:create, :update, :best]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:success] = 'Your answer has been saved!'
    else
      flash.now[:danger] = 'Error! The answer has not been saved!'
    end
  end

  def destroy
    return unless current_user.author_of?(@answer)
    if @answer.destroy
      flash[:warning] = 'Your answer has been deleted'
    else
      flash.now[:danger] = 'Error! The answer has not been deleted!'
    end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @answers = @question.answers
  end

  def best
    @answer.set_best if current_user.author_of?(@question)
    @answers = @question.answers
  end

  private

  def find_question
    if params[:question_id]
      @question = Question.find(params[:question_id])
    else 
      @question = @answer.question
    end
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
