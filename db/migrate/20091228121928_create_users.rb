class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :null => false
      t.string :hashed_password, :null => false
      t.string :salt, :null => false

      t.timestamps
    end

    add_index :users, :name, :unique => true

  end

  def self.down
    drop_table :users
  end
end
