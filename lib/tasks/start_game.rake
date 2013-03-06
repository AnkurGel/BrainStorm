namespace :game do
  desc "Start the game"
  task :start => :environment do
    if Game.all.empty?
      Game.create(:is_playable => false)
    end
    Game.first.update_attributes(:is_playable => true)
    puts "BrainStorm has begun..."
  end
end
