# frozen_string_literal: true

class User < ApplicationRecord
  include TweetsConcern

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
  has_many :replies, class_name: 'Tweet', foreign_key: 'parent_id', dependent: :destroy, inverse_of: :parent
  has_many :retweets, dependent: :destroy
  has_many :retweet_tweets, through: :retweets, source: :tweet
  has_many :likes, dependent: :destroy
  has_many :like_tweets, through: :likes, source: :tweet
  has_many :bookmarks, dependent: :destroy
  # 中間テーブルのbookmarksを経由して、tweetテーブルを参照する。中間テーブルであるbookmarksのcreated_atを降順に並べ替える。
  has_many :bookmarked_tweets, -> { order('bookmarks.created_at DESC') }, through: :bookmarks, source: :tweet

  # ユーザーが送信者となっている会話
  has_many :conversations_as_sender, foreign_key: :sender_id, class_name: 'Conversation', dependent: :destroy,
                                     inverse_of: :sender
  # ユーザーが受信者となっている会話
  has_many :conversations_as_recipient, foreign_key: :recipient_id, class_name: 'Conversation', dependent: :destroy,
                                        inverse_of: :recipient
  # 通知に関するアソシエーション
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'action_user_id', dependent: :destroy,
                                  inverse_of: 'action_user'
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'passive_user_id', dependent: :destroy,
                                   inverse_of: 'passive_user'

  # ユーザーのバリデーション
  validates :tel, presence: true, unless: :from_omniauth?
  validates :birthday, presence: true, unless: :from_omniauth?
  validates :name, length: { maximum: 20 }
  validates :description, length: { maximum: 200 }
  validates :place, length: { maximum: 50 }
  validates :website, length: { maximum: 100 },
                      format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/, allow_blank: true }

  # フロフィール画像
  has_one_attached :profile_image
  has_one_attached :header_image

  def display_image
    if profile_image.attached?
      profile_image
    else
      'https://source.unsplash.com/phIFdC6lA4E/40x40'
    end
  end

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

  # DMに関するメソッド
  def conversations
    Conversation.where(sender_id: id).or(Conversation.where(recipient_id: id))
  end

  def find_or_create_conversation_with(other_user)
    Conversation.between(id, other_user.id).first ||
      Conversation.find_or_create_by(sender_id: id, recipient_id: other_user.id)
  end

  # 通知に関するメソッド（ツイートに関する）
  def create_notification(tweet, action)
    return if id == tweet.user_id

    notification = active_notifications.new(
      tweet_id: tweet.id,
      passive_user_id: tweet.user_id,
      action: action
    )
    # バリデーション通れば、保存して通知メール送信
    return unless notification.save

    NotificationMailer.notification_email(tweet.user).deliver_later
  end
end
