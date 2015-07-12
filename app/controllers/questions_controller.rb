class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :show, :index ]

  def new
    @question = Question.new
  end

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      flash[:success] = 'Ваш вопрос успешно создан!'
      redirect_to @question
    else
      flash.now[:danger] = 'Ошибка! Не удалось создать Ваш вопрос!'
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
