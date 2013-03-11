class RegistrationsController < Devise::RegistrationsController
  before_filter :admin_user, :only => [:destroy]
  before_filter :update_only_before_play, :only => [:edit, :update]

  def create
    if simple_captcha_valid?
      super
    else
      build_resource
      clean_up_passwords(resource)
      flash.now[:alert] = "There was an error with the captcha code below. Please re-enter the code."      
      render :new
    end
  end
  def update
    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to fame_path
  end

  private
  def update_only_before_play
    redirect_to root_path, :notice => "You can't update your profile at this moment. Play now!" if current_user.score != 1
    #To ensure that profile is not updated during game play,
    #otherwise, this will impact the ranking of same rank holders
  end
end
