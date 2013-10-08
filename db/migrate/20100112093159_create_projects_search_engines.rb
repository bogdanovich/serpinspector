class CreateProjectsSearchEngines < ActiveRecord::Migration
  def self.up
    create_table :projects_search_engines, :id => false do |t|
      t.references :project, :null => false
      t.references :search_engine, :null => false
      t.timestamps
    end

    add_index :projects_search_engines, [:project_id, :search_engine_id], :unique => true
  end

  def self.down
    drop_table :projects_search_engines
  end
end
