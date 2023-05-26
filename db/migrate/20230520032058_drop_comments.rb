# frozen_string_literal: true

# db/migrate/YYYYMMDDHHMMSS_drop_comments.rb
class DropComments < ActiveRecord::Migration[7.0]
  def up
    drop_table :comments
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
