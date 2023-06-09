# frozen_string_literal: true

module TweetsConcern
  extend ActiveSupport::Concern

  # ツイートに関するメソッド
  def following_tweets
    Tweet.where(user_id: following.ids, parent_id: nil).order(created_at: :desc)
  end

  def all_tweets
    Tweet.where(parent_id: nil).order(created_at: :desc)
  end

  def ordered_tweets
    tweets.where(parent_id: nil).order(created_at: :desc)
  end

  def ordered_retweets
    retweet_tweets.order(created_at: :desc)
  end

  def ordered_replies
    tweets.where.not(parent_id: nil).order(created_at: :desc)
  end

  def ordered_likes
    like_tweets.order(created_at: :desc)
  end
end
