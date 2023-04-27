class AddColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :tel, :string, null: false
    add_column :users, :birthday, :datetime, null: false
    add_column :users, :name, :string
    add_column :users, :description, :string
    add_column :users, :place, :string
    add_column :users, :website, :string
  end
end
