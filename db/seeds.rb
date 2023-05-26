# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 既存Seedsデータを削除
# User.destroy_all

# ユーザーを作成
# user1 = User.create!(email: 'user1@example.com', password: 'password', password_confirmation: 'password',
#                      name: 'user1', birthday: '1990-01-01', tel: '090-1234-5678', confirmed_at: Time.zone.now,
#                     description: 'こんにちは', place: '大阪府', website: 'https://example.text')
# user2 = User.create!(email: 'user2@example.com', password: 'password', password_confirmation: 'password',
#                      name: 'user2', birthday: '1990-01-01', tel: '090-1234-5678', confirmed_at: Time.zone.now,
#                     description: 'こんにちは', place: '大阪府', website: 'https://example.text')
# user3 = User.create!(email: 'user3@example.com', password: 'password', password_confirmation: 'password',
#                      name: 'user3', birthday: '1990-01-01', tel: '090-1234-5678', confirmed_at: Time.zone.now,
#                     description: 'こんにちは', place: '大阪府', website: 'https://example.text')
# myAccount = User.create!(
#                      email: 'shuuuya0616@gmail.com', password: 'password', password_confirmation: 'password',
#                      name: 'hiranuma', birthday: '1995-06-11', tel: '090-1234-5678', confirmed_at: Time.zone.now,
#                      description: 'こんにちは', place: '大阪府', website: 'https://example.text')

# myAccount.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/sora.jpg')), filename: 'sora.jpg')
# myAccount.header_image.attach(io: File.open(Rails.root.join('app/assets/images/nature.jpg')), filename: 'nature.jpg')

# # # ツイートを作成 (各ユーザーが10個ずつ)
# 10.times do |i|
#   user1.tweets.create!(content: "こんにちは！ツイートです！ user1がツイートしています！! ツイート番号は： ##{i + 1}")
#   user2.tweets.create!(content: "こんにちは！ツイートです！ user2がツイートしています！! ツイート番号は： ##{i + 1}")
#   user3.tweets.create!(content: "こんにちは！ツイートです！ user3がツイートしています！! ツイート番号は： ##{i + 1}")
#   myAccount.tweets.create!(content: "こんにちは！ツイートです！ myAccountがツイートしています！! ツイート番号は： ##{i + 1}")
# end

# # # フォロー関係を作成
# user1.follow(user2)
# user1.follow(user3)
# user2.follow(user3)
# user3.follow(user1)
# myAccount.follow(user1)

# tweet1 = user1.tweets.create!(content: "こんにちは！ツイートです！色々ようです！")
# Retweet.create!(user: myAccount, tweet: tweet1)
# Comment.create!(content: "Comment 1", user: myAccount, tweet: tweet1)
# Like.create!(user: myAccount, tweet: tweet1)

# 全ての既存ユーザーで、ツイートを作成し、ランダムなツイートをリツイート・いいね・コメントをする
User.all.each do |user|
  tweet = user.tweets.create!(content: 'こんにちは！ツイートです！')
  tweet.update!(content: "#{tweet.content} tweets_ID: #{tweet.id}")
  random_tweet1 = Tweet.all.sample
  # random_tweet2 = Tweet.all.sample
  random_tweet3 = Tweet.all.sample
  Retweet.create!(user: user, tweet: random_tweet1)
  # Comment.create!(content: 'コメントです！コメントです！}', user: user, tweet: random_tweet2)
  Like.create!(user: user, tweet: random_tweet3)
end
