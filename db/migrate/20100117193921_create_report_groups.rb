class CreateReportGroups < ActiveRecord::Migration
  def self.up
    create_table :report_groups do |t|
      t.string :name, :null => false

      t.timestamps
    end
    add_index :report_groups, :name, :unique => true
  end

  def self.down
    drop_table :report_groups
  end
end
