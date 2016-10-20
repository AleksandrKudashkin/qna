class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_question, only: [:show, :destroy, :update, :subscribe, :unsubscribe]
  before_action :load_answers, only: :show
  after_action :publish_question, only: :create

  respond_to :js

  authorize_resource

  def new
    respond_with(@question = Question.new)
  end

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question)
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    return unless current_user.author_of?(@question)
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    current_user.author_of?(@question) ? respond_with(@question.destroy) : redirect_to(@question)
  end

  def subscribe
    @question.subscribe(current_user)
  end

  def unsubscribe
    @question.unsubscribe(current_user)
  end

  private

  def find_question
    @question = Question.find(params[:id]) if params[:id]
    @question = Question.find(params[:question_id]) if params[:question_id]
  end

  def load_answers
    @answers = @question.answers
  end

  def publish_question
    PrivatePub.publish_to "/questions", question: @question.to_json if @question.valid?
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
