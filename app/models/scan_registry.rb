class ScanRegistry < ActiveRecord::Base
  
  self.table_name = 'scan_registry'

  def self.best_positions_for(site_url)
    best_positions = Hash.new{|h,k| h[k] = Hash.new(&h.default_proc) }
    positions = ScanRegistry.where(:key => 'best_position', :site => site_url)
    for position in positions
      best_positions[position.keyword][position.search_engine] = position.value.to_s
    end if positions
    best_positions
  end

  def self.last_position(site_name, keyword_name, search_engine_name)
    get_scan_registry_value('last_position', site_name, keyword_name, search_engine_name)
  end

  def self.best_position(site_name, keyword_name, search_engine_name)
    get_scan_registry_value('best_position', site_name, keyword_name, search_engine_name)
  end

  def self.get_scan_registry_value(key, site_name, keyword_name, search_engine_name)
    return ScanRegistry.find_or_create(:key => key, :site => site_name, :keyword => keyword_name, :search_engine => search_engine_name)
  end

  def self.find_or_create opts
    ScanRegistry.where(opts).first || ScanRegistry.create(opts)
  end


end
