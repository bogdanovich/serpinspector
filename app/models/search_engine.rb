class SearchEngine < ActiveRecord::Base
  has_and_belongs_to_many :projects
  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_presence_of   :main_url
  validates_format_of     :main_url, :with => URI::regexp(%w(http https)), :message => ": should be valid URL"
  validates_presence_of   :query_input_selector
  validates_format_of     :query_input_selector, :with => /(?:name|id|class):[a-zA-Z0-9\-_\.:]+/, 
                          :message => ": should be valid selector (id:<tag>), (name:<tag>) or (class:<tag>)"
  validates_presence_of   :item_regex
  validates_presence_of   :next_page_selector
  validates_format_of     :next_page_selector, :with => /(?:name|id|class):[a-zA-Z0-9\-_\.:]+/,
                          :message => ": should be valid selector (id:<tag>), (name:<tag>) or (class:<tag>)"

end
