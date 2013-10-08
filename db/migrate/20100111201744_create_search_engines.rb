class CreateSearchEngines < ActiveRecord::Migration
  def self.up
    create_table :search_engines do |t|
      t.string :name, :null => false
      t.string :query_template, :null => false
      t.string :item_regex, :null => false
      t.string :next_page_regex, :null => false
      t.integer :next_page_delay, :null => false, :default => 15
      t.integer :version, :null => false, :default => 0
      t.boolean :active, :default => true

      t.timestamps
    end

    add_index :search_engines, :active
    add_index :search_engines, :name, :unique => true
  end

  def self.down
    drop_table :search_engines
  end
end
