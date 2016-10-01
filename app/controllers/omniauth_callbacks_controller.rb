class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    provider_callback("Facebook")
  end

  def twitter
    provider_callback("Twitter")
  end

  private

  def provider_callback(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    return unless @user.persisted?
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
  end
end
