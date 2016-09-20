class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [:show, :index]
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
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      PrivatePub.publish_to "/questions/index", question: @question.to_json
      flash[:success] = 'Your question has been created!'
      redirect_to @question
    else
      flash.now[:danger] = 'Error! The question has not been created!'
      render :new
    end
  end

  def update
    return unless current_user.author_of?(@question)
    if @question.update(question_params)
      flash[:success] = 'Your question has been updated'
    else
      flash.now[:danger] = 'Error! The question has not been updated!'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      if @question.destroy
        flash[:warning] = 'Your question has been deleted!'
      else
        flash.now[:danger] = 'Error! Your question has not been deleted!'
      end
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
