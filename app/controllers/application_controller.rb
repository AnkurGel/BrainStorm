class ApplicationController < ActionController::Base
  protect_from_forgery

  def admin_user
    redirect_to root_path, notice: "sudo says: YOU SHALL NOT PASS!" unless current_user and current_user.admin?
  end

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
