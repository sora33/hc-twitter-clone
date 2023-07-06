# frozen_string_literal: true

FactoryBot.define do
  factory :tweet do
    content { 'Tweet content' }
    association :user

    trait :with_image do
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/files/sora.jpg'), 'image/jpeg') }
    end
  end
end
