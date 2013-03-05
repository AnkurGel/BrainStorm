class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g.
    # app/models/user.rb)
    @user, new_record = User.find_or_create(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      if new_record
        sign_in @user
        redirect_to edit_user_registration_path
      else
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
