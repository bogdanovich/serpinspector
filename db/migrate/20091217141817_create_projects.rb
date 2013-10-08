class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name, :null => false
      t.integer :search_depth, :default => 100, :null => false
      t.string :scheduler_mode, :default => 'On Demand', :null => false
      t.integer :scheduler_factor, :default => 1, :null => false
      t.time :scheduler_time, :default => Time.parse('06:00'), :null => false
      t.integer :scheduler_day, :default => 1, :null => false
      t.datetime :last_scheduled_at
      t.datetime :last_scanned_at
      t.timestamps 
    end
    add_index :projects, :scheduler_mode
    add_index :projects, :name, :unique => true
  end

  def self.down
    drop_table :projects
  end
end
