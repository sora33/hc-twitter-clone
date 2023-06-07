# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :body, :conversation_id, :user_id, presence: true
  # バリデーション
  validates :body, length: { maximum: 140 }
end
