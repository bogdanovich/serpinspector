class Report < ActiveRecord::Base
  belongs_to :report_group
  has_many :report_items, :dependent => :destroy 
  
  def prepare
    items = self.report_items
    not_scanned_symbol = Settings.not_scanned_symbol
    report = {}
    report['data']           = Hash.new{|h,k| h[k] = Hash.new(&h.default_proc) }
    report['best_positions'] = Hash.new{|h,k| h[k] = Hash.new(&h.default_proc) }
    report['columns']        = []
    report['rows']           = []
    for item in items
      report['data'][item.site][item.keyword][item.search_engine] = {'position' => item.position, 'position_change' => item.position_change}
      report['columns'] << item.search_engine unless report['columns'].include?(item.search_engine)
      report['rows']    << item.keyword unless report['rows'].include?(item.keyword)
    end unless items.nil?
    # fill blank positions with not_scanned_symbol
    for site in report['data'].keys
      best_positions = ScanRegistry.best_positions_for(site)
      #p best_positions
      for keyword in report['rows']
        for search_engine in report['columns']
          if report['data'][site][keyword][search_engine]['position'].blank?
            report['data'][site][keyword][search_engine]['position'] = not_scanned_symbol
          end
          report['data'][site][keyword][search_engine]['position_best'] = best_positions[keyword][search_engine]
        end
      end
    end
    report
  end

end
