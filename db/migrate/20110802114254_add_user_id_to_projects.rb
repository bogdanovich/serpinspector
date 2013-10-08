class AddUserIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :user_id, :integer, :null => false, :default => 1
    add_index :projects, :user_id
  end

  def self.down
    remove_column :projects, :user_id
    remove_index :projects, :scheduler_mode
  end
end
