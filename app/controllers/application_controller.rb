require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { errors: exception.message }, status: 403 }
      format.js do
        @error = exception.message
        render 'application/cancan', status: 403
      end
    end
  end

  check_authorization unless :devise_controller?
end
