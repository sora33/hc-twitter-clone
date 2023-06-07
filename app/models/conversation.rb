# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :recipient_id }

  # 特定のユーザーに関するメッセージを取得する
  scope :between, lambda { |sender_id, recipient_id|
    where(sender_id: sender_id, recipient_id: recipient_id)
      .or(where(sender_id: recipient_id, recipient_id: sender_id))
  }

  # 自分じゃないユーザーを取得する
  def other_user(user)
    sender == user ? recipient : sender
  end

  # 最新のメッセージを取得する
  def last_message
    messages.order(created_at: :desc).first
  end
end
