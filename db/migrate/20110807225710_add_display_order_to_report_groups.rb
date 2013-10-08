class AddDisplayOrderToReportGroups < ActiveRecord::Migration
  def self.up
    add_column :report_groups, :display_order, :integer
    remove_index :report_groups, :user_id
    add_index :report_groups, [:user_id, :display_order]
  end

  def self.down
    remove_index :report_groups, [:user_id, :display_order]
    remove_column :report_groups, :display_order
    add_index :report_groups, :user_id
  end
end
