# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :retweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  # 自己結合（コメント）
  belongs_to :parent, class_name: 'Tweet', optional: true
  has_many :replies, class_name: 'Tweet', foreign_key: 'parent_id', dependent: :destroy, inverse_of: :parent
  # バリデーション
  validates :content, presence: true, length: { maximum: 140 }
end
