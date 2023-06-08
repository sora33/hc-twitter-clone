# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# ユーザーが見つからなかった場合に新規作成
seed_user = User.find_by(email: 'seeduser1212345@example.com')
seed_user ||= User.create(
  email: 'seeduser1212345@example.com',
  password: 'password',
  password_confirmation: 'password',
  name: 'seeduser1212345',
  birthday: '1990-01-01',
  tel: '090-1234-5678',
  confirmed_at: Time.zone.now,
  description: 'こんにちは',
  place: '大阪府',
  website: 'https://example.text'
)

tweet_content = <<-CONTENT
                自動で作成されたツイートです。
                こんちにちは、

                今日は雨ですね。
CONTENT

users = User.all
users.each do |user|
  tweet = user.tweets.create!(content: tweet_content)
  like = seed_user.likes.build(tweet_id: tweet.id)
  retweet = seed_user.retweets.build(tweet_id: tweet.id)
  bookmark = seed_user.bookmarks.build(tweet_id: tweet.id)

  seed_user.create_notification(tweet, 'like') if like.save
  seed_user.create_notification(tweet, 'retweet') if retweet.save
  seed_user.create_notification(tweet, 'bookmark') if bookmark.save
end
