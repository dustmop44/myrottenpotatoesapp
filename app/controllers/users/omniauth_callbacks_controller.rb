class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    auth = request.env['omniauth.auth']
    unless identity = Identity.find_from_omniauth(auth)
      user = User.from_omniauth(auth)
      identity = Identity.create_from_omniauth(auth, user)
    end
    if identity.user.persisted?
      sign_in_and_redirect identity.user, event: :authentication
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
  
  def facebook
    auth = request.env['omniauth.auth']
    unless identity = Identity.find_from_omniauth(auth)
      user = User.from_omniauth(auth)
      identity = Identity.create_from_omniauth(auth, user)
    end
    if identity.user.persisted?
      sign_in_and_redirect identity.user, event: :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end
  
=begin
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end
  
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
  
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:twitter, :facebook, :linked_in].each do |provider|
    provides_callback_for provider
  end
=end
  
  def failure
    redirect_to root_path
  end
end
