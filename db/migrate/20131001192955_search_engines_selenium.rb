class SearchEnginesSelenium < ActiveRecord::Migration
  def change
    change_table :search_engines do |t|
      t.remove :query_template, :next_page_regex
      t.string :main_url,             :null => false, :after => :name
      t.string :query_input_selector, :null => false, :after => :main_url 
      t.string :next_page_selector,   :null => false, :after => :item_regex
    end   
  end
end
