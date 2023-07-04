FactoryBot.define do
  factory :tweet do
    content { "Tweet content" }
    association :user

    trait :with_image do
      image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/files/sora.jpg", 'image/jpeg') }
    end
  end
end
