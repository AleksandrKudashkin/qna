class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :show, :index ]
  before_action :find_question, only: [:show, :destroy]
  
  def new
    @question = Question.new
  end

  def index
    @questions = Question.all
  end

  def show
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      flash[:success] = 'Ваш вопрос успешно создан!'
      redirect_to @question
    else
      flash.now[:danger] = 'Ошибка! Не удалось создать Ваш вопрос!'
      render :new
    end
  end

  def destroy
    if @question.user == current_user
      @question.destroy ? flash[:warning] = 'Ваш вопрос удалён!' : flash.now[:danger] = 'Ошибка! Не удалось удалить Ваш вопрос!'
    end
    redirect_to questions_path
  end

  private

    def question_params
      params.require(:question).permit(:title, :body)
    end

    def find_question
      @question = Question.find(params[:id])
    end
end
