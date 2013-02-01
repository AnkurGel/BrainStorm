class LevelsController < ApplicationController
  before_filter :admin_user, :only => [:create, :update, :destroy]
  before_filter :registered_user, :only => [:show]

  def show
    @level = Level.find(params[:id])
    redirect_to @level if params[:redirect_to_correct_location]
  end
  def create
    @level = Level.set(params[:level])
    @level_last = Level.last
    if @level.save
      @level_last.update_attributes(:next_id => Level.last.id) if @level_last
      flash[:success] = "Level created."
      redirect_to admin_path
    else
      render 'default_pages/admin'
    end
  end

  def update
  end

  private
  def admin_user
    redirect_to root_path, notice: "sudo says: YOU SHALL NOT PASS!" unless current_user and current_user.admin?
  end

  def registered_user
    redirect_to root_path, notice: "Register or Sign in to play." unless current_user
    if current_user and not current_user.admin?
      params[:redirect_to_correct_location] = true if params[:id].to_i != current_user.score
      params[:id] = current_user.score
    end
  end
end
