FactoryGirl.define do
  factory :user do
    email                  "ankurgel@gmail.com"
    name                   "Ankur Goel"
    password               'hocuspocus'
    password_confirmation  'hocuspocus'

    factory :admin do
      email "admin@bstorm.in"
      admin true
    end
  end
end
