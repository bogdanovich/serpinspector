class ReportItem < ActiveRecord::Base
  belongs_to :report
  validates_presence_of :search_engine
  validates_presence_of :site
  validates_presence_of :keyword
  validates_presence_of :position

  def self.js_for_plot(site, keyword, search_engine)
    report_items = where("site = ? and keyword = ? and search_engine = ?", site, keyword, search_engine)
    js = 'var positions_dataset = [ '
    for item in report_items
      position =  (item.position.to_i > 0) ? item.position : 'null'
      js << "\n[Date.UTC(#{item.updated_at.to_time.year},#{item.updated_at.to_time.month-1},#{item.updated_at.to_time.day}), #{position}],"
    end
    js = js.chop + "\n];"
  end

end
