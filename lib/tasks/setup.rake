namespace :game do
  desc "Setup the game for first run"
  task :setup => :environment do
    puts "Setting first user as admin..."
    unless User.all.empty?
      User.first.toggle!(:admin)
      puts "Adding colleges ..."
      Rake::Task["db:seed"].invoke
      puts "Setting up the game plug ..."
      if Game.all.empty?
        Game.create!
      end
      puts "Run rake game:start to switch it on!"
    else
      puts "Please run 'rake db:create' and 'rake db:migrate' first if you haven't"
      puts "Also, no user is currently present. You sir, should create the first user now!"
    end
  end
end
