class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with profiles_without_current
  end

  protected

  def current_resource_owner
    return unless doorkeeper_token
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
  end

  def profiles_without_current
    @profiles = User.where.not(id: current_resource_owner.id) if current_resource_owner
  end
end
