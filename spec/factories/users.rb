FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    tel { "1234567890" }
    birthday { Date.today }
    website { "http://www.example.com" }
    password { "password" }
  end
end
