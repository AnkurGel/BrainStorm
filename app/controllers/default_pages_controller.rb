class DefaultPagesController < ApplicationController
  before_filter :admin_user, :only => [:admin]
  def home
  end

  def fame
  end

  def admin
    @level = Level.new
  end

  def contact
  end

  private
  def admin_user
    redirect_to root_path, notice: "sudo says: YOU SHALL NOT PASS!" unless current_user and current_user.admin?
  end
end
