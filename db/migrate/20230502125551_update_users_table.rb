# frozen_string_literal: true

class UpdateUsersTable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :tel, true
    change_column_null :users, :birthday, true
  end
end
