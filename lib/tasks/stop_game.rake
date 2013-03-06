namespace :game do
  desc "Stop the game"
  task :stop => :environment do
    Game.first.update_attributes(:is_playable => false)
    puts "BrainStorm is over.."
  end
end
