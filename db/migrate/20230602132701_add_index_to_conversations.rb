# frozen_string_literal: true

class AddIndexToConversations < ActiveRecord::Migration[7.0]
  def change
    add_index :conversations, %i[sender_id recipient_id], unique: true
  end
end
