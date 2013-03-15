class AttemptsController < ApplicationController
  before_filter :game_playable?, :only => [:create]
  def create
    @attempt = current_user.attempts.build(params[:attempt])
    @attempt.level_id = current_level
    @level = Level.find(current_level)
    if @attempt.save
      if sterlize(@attempt.attempt).eql? @level.answer
        unless current_user.admin?
          current_user.score = @level.next_id;
          current_user.last_correct_answer_at = Time.now
          current_user.save
          if current_user.has_publish_permission?
            begin
              current_user.facebook.put_wall_post("Just cleared level #{@level.id} in BrainStorm - online treasure hunt. #{insert_random_praise}! - http://bstorm.in")
            rescue Koala::Facebook::APIError => e
              flash[:success] = "Level cleared!"
              redirect_to level_path(current_level)
            end
          end
        end
        flash[:success] = "Level cleared!"
        redirect_to level_path(current_level)
      else
        flash[:error] = "Wrong! Needs more brainstorming"
        redirect_to level_path(current_level)
      end
    else
      @attempts = Attempt.find_all_by_user_id_and_level_id(current_user.id, @level.id)
      render 'levels/show'
    end
  end
end
