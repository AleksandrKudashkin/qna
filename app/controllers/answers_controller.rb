class AnswersController < ApplicationController
  def new
    @answer = Answer.new
    @answer.question_id = params[:question_id]
  end

  def create
    @question = Question.find_by_id(params[:question_id])
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :answer_body)
  end
end
