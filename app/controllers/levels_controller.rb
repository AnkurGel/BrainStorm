class LevelsController < ApplicationController
  before_filter :admin_user, :only => [:create, :edit, :update, :destroy]
  before_filter :registered_user, :only => [:show, :play]
  before_filter :game_playable?, :only => [:show, :play]
  def show
    @level = Level.find(params[:id])
    @attempt = current_user.attempts.build
    @attempts = Attempt.find_all_by_user_id_and_level_id(current_user.id, @level.id)
    redirect_to @level, :notice => "LOLOLOL" if params[:redirect_to_correct_location]
  end

  def play
    redirect_to level_path(current_user.score)
  end

  def create
    @level = Level.set(params[:level]) # data massaging
    @level_last = Level.last
    if @level.save
      @level_last.update_attributes(:next_id => Level.last.id) if @level_last
      flash[:success] = "Level created."
      redirect_to @level
    else
      @college = College.new
      render 'default_pages/admin'
    end
  end

  def update
    @level = Level.find(params[:id])
    if @level.update_attributes(params[:level])
      flash[:success] = "Changes successfully registered"
      redirect_to @level
    else
      render 'default_pages/edit_question'
    end
  end

  def destroy
    @level = Level.find(params[:id])
    if @level.next_id.nil? #last_level
      Level.transaction do
        Level.find(@level.prev_id).update_attributes(:next_id => nil)
        @level.destroy
      end
    elsif !@level.next_id.nil? and !@level.prev_id.nil? #somewhere in middle
      @prev_level = Level.find(@level.prev_id)
      @next_level = Level.find(@level.next_id)
      Level.transaction do
        @prev_level.update_attributes(:next_id => @next_level.id)
        @next_level.update_attributes(:prev_id => @prev_level.id)
        @level.destroy
      end
    elsif @level.prev_id.nil? #first question
      @next_level = Level.find(@level.next_id) if @level.next_id
      Level.transaction do
        @level.destroy
        @next_level.update_attributes(:prev_id => nil) if @next_level and !@next_level.nil?
      end
    else
      redirect_to root_path, :error => "Some wild condition encountered, contact admin asap!" 
    end
    redirect_to admin_path
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
