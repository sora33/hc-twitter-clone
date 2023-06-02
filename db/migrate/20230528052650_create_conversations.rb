# frozen_string_literal: true

class CreateConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :conversations do |t|
      t.integer :sender_id
      t.integer :recipient_id

      t.timestamps
    end
    add_index :conversations, :sender_id
    add_index :conversations, :recipient_id
  end
end
