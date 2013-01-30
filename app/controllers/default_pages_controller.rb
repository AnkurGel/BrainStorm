class DefaultPagesController < ApplicationController
  before_filter :admin_user, :only => [:admin]
  def home
  end

  def fame
  end

  def admin
  end

  def contact
  end

  private
  def admin_user
    redirect_to root_path, notice: "Sign in with sudo powers, honey" unless current_user and current_user.admin?
  end
end
