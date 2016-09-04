class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_question
  before_action :find_answer, only: [:destroy, :update, :best]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save ? flash[:success] = 'Ваш ответ сохранён!' : flash.now[:danger] = 'Ошибка! Не удалось сохранить Ваш ответ!'
  end

  def destroy
    if @answer.user_id == current_user.id
      @answer.destroy ? flash[:warning] = 'Ваш ответ удалён!' : flash.now[:danger] = 'Ошибка! Не удалось удалить Ваш ответ!'
    end
  end

  def update
    @answer.update(answer_params) if @answer.user_id == current_user.id
    @answers = @question.answers
  end

  def best
    @answer.set_best if @question.user_id == current_user.id
    @answers = @question.answers
  end

  private

    def find_question
      @question = Question.find(params[:question_id])
    end

    def find_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:file])
    end
end
