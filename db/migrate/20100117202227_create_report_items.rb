class CreateReportItems < ActiveRecord::Migration
  def self.up
    create_table :report_items do |t|
      t.integer :report_id, :null => false
      t.string :site, :null => false
      t.string :keyword, :null => false
      t.string :search_engine, :null => false
      t.string :position, :null => false
      t.string :position_change

      t.timestamps
    end
  end

  def self.down
    drop_table :report_items
  end
end
