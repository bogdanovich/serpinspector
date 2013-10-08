class AddIndexesToReportItems < ActiveRecord::Migration
  def self.up
    add_index :report_items, [:site, :keyword, :search_engine]
  end

  def self.down
    remove_index :report_items, [:site, :keyword, :search_engine]
  end
end
