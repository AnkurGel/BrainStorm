class DefaultPagesController < ApplicationController
  before_filter :admin_user, :only => [:admin, :analytics, :edit_question, :admin_user_list, :view_attempts]
  def home
    if Game.first and Game.first.is_playable? and user_signed_in?
      @level_attempts = Attempt.level_attempt_chart_data(current_user)
    end
  end

  def fame
    @users = User.order('score DESC, last_correct_answer_at ASC, updated_at ASC').paginate(:page => params[:page], :per_page => 40)
    @page = params[:page].to_i - 1 if params[:page]
  end

  def admin
    @level = Level.new
    @college = College.new
    @users = User.all
  end

  def analytics
   # @registrations = User.select('DATE(created_at) created_at,
    # count(id) as total_ids').group("DATE(created_at)")
    @registrations = User.registration_data
    @colleges = User.colleges_bar_chart_data
    @users = User.order('score DESC')
    @level_attempts = Attempt.level_attempt_chart_data(current_user)
    @fb_non_fb_users = User.fb_non_fb_users_data
    @attempts_per_level = Attempt.attempts_per_level_data
  end

  def contact
  end

  def edit_question
    @level = Level.find(params[:id])
  end

  def team
  end

  def view_attempts
    @user = User.find(params[:id])
    @attempts_count = @user.attempts.count
    @attempts = @user.attempts.order('level_id ASC, created_at ASC').paginate(:page => params[:page], :per_page => 100)
  end

  def rules
  end

end
