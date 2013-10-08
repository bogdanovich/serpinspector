class ChangeIndexesProjects < ActiveRecord::Migration
  def self.up
    remove_index :projects, :name
    add_index :projects, [:name, :user_id], :unique => true
  end

  def self.down
    remove_index :projects, [:name, :user_id]
    add_index :projects, :name, :unique => true
  end
end
