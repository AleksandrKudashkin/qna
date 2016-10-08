class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :doorkeeper_authorize!

  respond_to :json

  protected

  def current_resource_owner
    return unless doorkeeper_token
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end
