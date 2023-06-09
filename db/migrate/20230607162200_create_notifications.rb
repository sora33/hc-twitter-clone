# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :action_user_id, null: false
      t.integer :passive_user_id, null: false
      t.integer :tweet_id
      t.string :action, default: '', null: false

      t.timestamps
    end
  end
end
