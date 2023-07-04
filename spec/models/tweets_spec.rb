# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tweet, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it 'has a valid factory with image' do
    tweet = FactoryBot.build(:tweet, :with_image, user: user)
    expect(tweet).to be_valid
  end

  it 'has a valid factory without image' do
    tweet = FactoryBot.build(:tweet, user: user)
    expect(tweet).to be_valid
  end

  it 'is invalid without content' do
    tweet = FactoryBot.build(:tweet, user: user, content: nil)
    tweet.valid?
    expect(tweet.errors[:content]).to include('を入力してください')
  end

  it 'User is invalid with a duplicate email address' do
    tweet = FactoryBot.build(:tweet, user: user, content: 'a' * 141)
    tweet.valid?
    expect(tweet.errors[:content]).to include('は140文字以下にしてください')
  end

  it 'can have many likes' do
    tweet = FactoryBot.create(:tweet, user: user)
    FactoryBot.create(:like, user: user, tweet: tweet)
    FactoryBot.create(:like, user: FactoryBot.create(:user), tweet: tweet)
    expect(tweet.likes.count).to eq(2)
  end

  it 'can have many replies' do
    tweet = FactoryBot.create(:tweet, user: user)
    FactoryBot.create(:tweet, user: user, parent: tweet)
    FactoryBot.create(:tweet, user: FactoryBot.create(:user), parent: tweet)
    expect(tweet.replies.count).to eq(2)
  end
end
