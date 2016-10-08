class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    respond_with current_resource_owner
  end

  def index
    respond_with profiles_without_current
  end

  protected

  def profiles_without_current
    @profiles = User.where.not(id: current_resource_owner.id) if current_resource_owner
  end
end
