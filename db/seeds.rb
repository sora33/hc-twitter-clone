# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 既存Seedsデータを削除
User.where('email like ?', '%@example.com').destroy_all

# ユーザーを作成
user1 = User.create!(email: 'user1@example.com', password: 'password', password_confirmation: 'password',
                     name: 'user1', birthday: '1990-01-01', tel: '090-1234-5678', confirmed_at: Time.zone.now)
user2 = User.create!(email: 'user2@example.com', password: 'password', password_confirmation: 'password',
                     name: 'user2', birthday: '1990-01-01', tel: '090-1234-5678', confirmed_at: Time.zone.now)
user3 = User.create!(email: 'user3@example.com', password: 'password', password_confirmation: 'password',
                     name: 'user3', birthday: '1990-01-01', tel: '090-1234-5678', confirmed_at: Time.zone.now)

# ツイートを作成 (各ユーザーが10個ずつ)
20.times do |i|
  user1.tweets.create!(content: "Hello from user1! Tweet ##{i + 1}")
  user2.tweets.create!(content: "Hello from user2! Tweet ##{i + 1}")
  user3.tweets.create!(content: "Hello from user3! Tweet ##{i + 1}")
end

# フォロー関係を作成
user1.follow(user2)
user1.follow(user3)
user2.follow(user3)
user3.follow(user1)
User.find_by(email: 'shuuuya0616@gmail.com').follow(user1)
