class DefaultPagesController < ApplicationController
  before_filter :admin_user, :only => [:admin, :analytics, :edit_question, :admin_user_list]
  def home
  end

  def fame
    @users = User.order('score DESC, updated_at ASC').paginate(:page => params[:page], :per_page => 20)
  end

  def admin
    @level = Level.new
    @college = College.new
    @users = User.all
  end

  def analytics
    @registrations = User.select('DATE(created_at) created_at, count(id) as total_ids').group("DATE(created_at)")
    @colleges = User.colleges_bar_chart_data
    @users = User.order('score DESC')
    @level_attempts = Attempt.level_attempt_chart_data(current_user)

  end

  def contact
  end

  def edit_question
    @level = Level.find(params[:id])
  end

  def team
  end

  private
  def admin_user
    redirect_to root_path, notice: "sudo says: YOU SHALL NOT PASS!" unless current_user and current_user.admin?
  end
end
