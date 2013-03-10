class DefaultPagesController < ApplicationController
  before_filter :admin_user, :only => [:admin, :analytics, :edit_question, :admin_user_list]
  def home
    if Game.first and Game.first.is_playable? and user_signed_in?
      @level_attempts = Attempt.level_attempt_chart_data(current_user)
    end
  end

  def fame
    @users = User.order('score DESC, updated_at ASC').paginate(:page => params[:page], :per_page => 4)
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

  end

  def contact
  end

  def edit_question
    @level = Level.find(params[:id])
  end

  def team
  end

  def rules
  end

end
