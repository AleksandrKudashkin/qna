module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:vote_up, :vote_down, :cancel_vote]
    before_action :authorize_voting, only: [:vote_up, :vote_down, :cancel_vote]
  end

  def vote_up
    authorize! :vote_up, @votable
    if current_user.voted_for?(@votable)
      respond_to_json_with_errors
    else
      set_vote(1)
      respond_to_json
    end
  end

  def vote_down
    authorize! :vote_down, @votable
    if current_user.voted_for?(@votable)
      respond_to_json_with_errors
    else
      set_vote(-1)
      respond_to_json
    end
  end

  def cancel_vote
    authorize! :cancel_vote, @votable
    if current_user.voted_for?(@votable)
      @votable.votes.find_by(user: current_user).destroy
      respond_to_json
    else
      respond_to_json_with_errors
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end

  def set_vote(value)
    @vote = @votable.votes.build
    @vote.user = current_user
    @vote.vote = value
    @vote.save
  end

  def respond_to_json_with_errors
    respond_to do |format|
      format.json { render json: { error: 'Ошибка!' } }
    end
  end

  def respond_to_json
    respond_to do |format|
      format.json { render json: @votable.votes.sum(:vote) }
    end
  end

  def authorize_voting
    authorize! action_name.to_sym, @votable
  end
end
