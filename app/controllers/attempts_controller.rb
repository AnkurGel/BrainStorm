class AttemptsController < ApplicationController
  before_filter :game_playable?, :only => [:create]
  def create
    @attempt = current_user.attempts.build(params[:attempt])
    @attempt.level_id = current_level
    @level = Level.find(current_level)
    if @attempt.save
      if sterlize(@attempt.attempt).eql? @level.answer
        current_user.score = @level.next_id;
        current_user.save
        redirect_to level_path(current_level), :success => "WIN WIN"
      else
        redirect_to level_path(current_level), :error => "NOOO"
      end
    else
      @attempts = Attempt.find_all_by_user_id_and_level_id(current_user.id, @level.id)
      render 'levels/show'
    end
  end
end
