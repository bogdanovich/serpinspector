class AddUserIdToReportGroups < ActiveRecord::Migration
  def self.up
    add_column :report_groups, :user_id, :integer, :null => false, :default => 1
    add_index :report_groups, :user_id
  end

  def self.down
    remove_column :report_groups, :user_id
    remove_index :report_groups, :user_id
  end
end
