class CreateKeywords < ActiveRecord::Migration
  def self.up
    create_table :keywords do |t|
      t.integer :project_id, :null => false
      t.string :name, :null => false
      t.integer :order

      t.timestamps
    end

    add_index :keywords, [:name, :project_id], :unique => true
  end

  def self.down
    drop_table :keywords
  end
end
