# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    association :action_user, factory: :user
    association :passive_user, factory: :user
    association :tweet
    notify_type { 'like' }
  end
end
