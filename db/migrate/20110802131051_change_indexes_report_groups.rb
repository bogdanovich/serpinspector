class ChangeIndexesReportGroups < ActiveRecord::Migration
  def self.up
    remove_index :report_groups, :name
    add_index :report_groups, [:name, :user_id], :unique => true
  end

  def self.down
    remove_index :report_groups, [:name, :user_id]
    add_index :report_groups, :name, :unique => true
  end
end
