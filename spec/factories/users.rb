# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Test User' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    tel { '1234567890' }
    birthday { Date.current }
    website { 'http://www.example.com' }
    password { 'password' }
  end
end
