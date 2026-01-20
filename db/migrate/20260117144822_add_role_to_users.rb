class AddRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :role, :integer, null: false, default: 0
    add_column :users, :time_zone, :string, null: false, default: "UTC"
  end
end
