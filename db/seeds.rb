# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
f = File.open("#{Rails.root}/db/colleges", 'rb')
f.each_with_index do |line, index|
  puts "Creating #{index + 1}"
  College.create(:name => line.gsub(/\n/,''))
end
