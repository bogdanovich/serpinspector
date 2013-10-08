class CreateScanRegistry < ActiveRecord::Migration
  def self.up
    create_table :scan_registry do |t|
      t.string :key, :null => false
      t.string :site, :null => false
      t.string :keyword, :null => false
      t.string :search_engine, :null => false
      t.string :value
      t.timestamps
    end
    add_index :scan_registry, [:key, :site, :keyword, :search_engine], :unique => true, :name => 'index_scan_registry'
  end

  def self.down
    drop_table :scan_registry
  end
end
