class DefaultPagesController < ApplicationController
  before_filter :admin_user, :only => [:admin, :analytics, :edit_question]
  def home
  end

  def fame
    @users = User.order('score DESC')
  end

  def admin
    @level = Level.new
    @college = College.new
  end

  def analytics
    @registrations = User.select('DATE(created_at) created_at, count(id) as total_ids').group("DATE(created_at)")
    @colleges = User.colleges_bar_chart_data
    @users = User.order('score DESC')
    @level_attempts = Attempt.level_attempt_chart_data

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
