class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.integer :report_group_id, :null => false
      t.datetime :notification_completed
      t.string :status
      t.string :scan_errors
      t.timestamps
    end
    add_index :reports, [:report_group_id,:created_at]
  end

  def self.down
    drop_table :reports
  end
end
