class AddRoleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string, :null => false, :default => 'user'
  end

  def self.down
    remove_column :users, :role
  end
end
