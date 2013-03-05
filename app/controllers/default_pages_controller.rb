class DefaultPagesController < ApplicationController
  before_filter :admin_user, :only => [:admin, :edit_question]
  def home
  end

  def fame
    @users = User.order('score DESC')
  end

  def admin
    @level = Level.new
    @college = College.new
  end

  def contact
  end

  def edit_question
    @level = Level.find(params[:id])
  end

  private
  def admin_user
    redirect_to root_path, notice: "sudo says: YOU SHALL NOT PASS!" unless current_user and current_user.admin?
  end
end
