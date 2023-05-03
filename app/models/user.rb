# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:github]

  validates :tel, presence: true, unless: :from_omniauth?
  validates :birthday, presence: true, unless: :from_omniauth?

  def self.find_for_github_oauth(auth)
    # GitHubアカウントがあれば返す
    user = User.where(provider: auth.provider, uid: auth.uid).first
    return user if user

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
        provider: auth.provider, uid: auth.uid
      )
      user.skip_confirmation! # 確認メールをスキップ
    else  # 既存のユーザーにGitHubの情報を追加
      user.update!(provider: auth.provider, uid: auth.uid)
    end
  end

  def self.create_unique_string
    SecureRandom.uuid
  end

  def from_omniauth?
    provider.present? && uid.present?
  end
end
