# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:github]

  # Relationships
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy,
                                  inverse_of: :follower
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy,
                                   inverse_of: :followed
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # ツイートに関するアソシエーション
  has_many :tweets, dependent: :destroy
  has_many :retweets, dependent: :destroy
  has_many :retweet_tweets, through: :retweets, source: :tweet
  has_many :comments, dependent: :destroy
  has_many :comment_tweets, through: :comments, source: :tweet
  has_many :likes, dependent: :destroy
  has_many :like_tweets, through: :likes, source: :tweet

  # ユーザーのバリデーション
  validates :tel, presence: true, unless: :from_omniauth?
  validates :birthday, presence: true, unless: :from_omniauth?
  validates :name, length: { maximum: 20 }
  validates :description, length: { maximum: 200 }
  validates :place, length: { maximum: 50 }
  validates :website, length: { maximum: 100 }, format: /\A#{URI::regexp(%w(http https))}\z/

  # フロフィール画像
  has_one_attached :profile_image
  has_one_attached :header_image

  def self.find_for_github_oauth(auth)
    # GitHubアカウントがあれば返す
    user = User.where(provider: auth.provider, uid: auth.uid).first

    if user
      user.update!(name: auth.info.name) if user.name.nil?
      return user
    end

    # 既存ユーザーがいれば返す、いなければ新規作成する
    user = User.where(email: auth.info.email).first_or_initialize
    assign_github_attributes(user, auth)
    user.save!
    user
  end

  def self.assign_github_attributes(user, auth)
    if user.new_record? # 新しいユーザーの場合
      user.assign_attributes(
        email: auth.info.email, password: Devise.friendly_token[0, 20],
        provider: auth.provider, uid: auth.uid, name: auth.info.name
      )
      user.skip_confirmation! # 確認メールをスキップ
    else # 既存のユーザーにGitHubの情報を追加
      user.update!(provider: auth.provider, uid: auth.uid)
    end
  end

  def self.create_unique_string
    SecureRandom.uuid
  end

  def from_omniauth?
    provider.present? && uid.present?
  end

  # ツイートに関するメソッド
  def following_tweets
    Tweet.where(user_id: following.ids)
  end

  def all_tweets
    Tweet.all.order(created_at: :desc)
  end

  def ordered_tweets
    tweets.order(created_at: :desc)
  end

  def ordered_retweets
    retweet_tweets.order(created_at: :desc)
  end

  def ordered_comments
    comment_tweets.order(created_at: :desc)
  end

  def ordered_likes
    like_tweets.order(created_at: :desc)
  end

  # フォローに関するメソッド
  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end
end
