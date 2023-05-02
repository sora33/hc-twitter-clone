# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:github]

  validates :tel, presence: true, unless: :from_omniauth?
  validates :birthday, presence: true, unless: :from_omniauth?

  # authはGitHubから送られてくるハッシュ。名前やメアドなどが入っている。
  # DBにデータなければ新規作成、見つかればそのデータを返す
  def self.find_for_github_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.info.email # user.name = auth.info.name
      user.password = Devise.friendly_token[0, 20] # 任意の20文字の文字列を作成する
      user.skip_confirmation! # 仮登録メールを介さずに即時登録
    end
  end

  def from_omniauth?
    provider.present? && uid.present?
  end
end
