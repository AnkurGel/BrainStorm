require 'faker'
FactoryGirl.define do
  factory :user do
    email                  "ankurgel@gmail.com"
    name                   "Ankur Goel"
    password               'hocuspocus'
    password_confirmation  'hocuspocus'
    college
#    association :college, factory: :college, strategy: :build

    factory :admin do
      name "Super Ninja"
      email "admin@bstorm.in"
      admin true
    end
  end

  factory :second_user, class: User do
    email                  "foo@bar.com"
    name                   "Foo Bar"
    password               'hocuspocus'
    password_confirmation  'hocuspocus'
    association :college, factory:  :second_college
  end

  sequence(:random_text) { |n| Faker::Lorem.characters(20) }

  factory :level_1, class: Level do
    question "What is answer of the life, the universe and everything?"
    answer   "42"
    prev_id  nil
    next_id  2
  end

  factory :level_2, class: Level do
    question "If you are at one in infinite loop, where are you?"
    answer   'Apple Headquarters'
    prev_id 1
    next_id nil
  end

  factory :attempt, class: Attempt do
    sequence(:attempt) { |n| "Text_#{n}" }
#    attempt { FactoryGirl.generate(:increment) }#Faker::Lorem.characters(20)
#    attempt { generate(:random_text) }
    association :level, factory: :level_1
    association :user,  factory: [:user, :second_user].shuffle.first
  end

  factory :college do
    name  "Indraprastha University"
  end

  factory :second_college, class: College do
    name "Maharaja Surajmal Institute of Technology"
  end

  factory :playable_game, class: Game do
    is_playable true

    factory :unplayable_game do
      is_playable false
    end
  end
end
