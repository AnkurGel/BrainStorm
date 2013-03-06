class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_level
    return (Level.last ? Level.last.id : 0) if current_user.admin?
    current_user.score
  end
  def sterlize(value)
    value.chomp.downcase.gsub(/[\W\n\s]/,'')
  end
  helper_method :current_level
  def game_playable?
    if (Game.first and Game.first.is_playable) or current_user.admin?
    else
      redirect_to root_path, :notice => "Brainstorm is not yet playable"
    end
  end
end
