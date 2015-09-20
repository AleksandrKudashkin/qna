class QuestionsController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, except: [ :show, :index ]
  before_action :find_question, only: [:show, :destroy, :update]
  
  def new
    @question = Question.new
  end

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers
    @rating = @question.votes.sum(:vote)
    #voting
    load_votable
    @has_voted = user_has_voted?
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

  def update
    if @question.user_id == current_user.id
      @question.update(question_params) ? flash[:success] = 'Ваш вопрос успешно отредактирован!' : flash.now[:danger] = 'Ошибка! Не удалось отредактировать Ваш вопрос!'
    end    
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy ? flash[:warning] = 'Ваш вопрос удалён!' : flash.now[:danger] = 'Ошибка! Не удалось удалить Ваш вопрос!'
    end
    redirect_to questions_path
  end

  private

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    end

    def find_question
      @question = Question.find(params[:id])
    end
end
