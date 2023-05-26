# frozen_string_literal: true

class AddParentIdToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :parent_id, :bigint
    add_index :tweets, :parent_id
  end
end
