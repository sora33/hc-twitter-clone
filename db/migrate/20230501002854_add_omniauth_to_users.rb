# frozen_string_literal: true

class AddOmniauthToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :provider
      t.string :uid
      t.index %i[provider uid], unique: true
    end
  end
end
