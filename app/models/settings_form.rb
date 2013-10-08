class SettingsForm
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :admin_email, :not_found_symbol, :not_scanned_symbol, :default_time_format

  validates_format_of :admin_email, :with => /\A\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)\z/ix
  validates_presence_of :admin_email, :not_found_symbol, :default_time_format

  def initialize(attributes={})
    attributes && attributes.each do |name, value|
      send("#{name}=", value) if respond_to? name.to_sym
    end
  end
  
  def self.attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat( vars )
    super
  end

 def self.attributes
   @attributes
 end

 def persisted?
   false
 end

 def self.inspect
   "#<#{ self.to_s} #{ self.attributes.collect{ |e| ":#{ e }" }.join(', ') }>"
 end

  def self.load_current
    return SettingsForm.new(:admin_email => Settings.admin_email,
                            :not_found_symbol => Settings.not_found_symbol,
                            :not_scanned_symbol => Settings.not_scanned_symbol,
                            :default_time_format => Settings.default_time_format)
  end

  def update
    Settings.admin_email               = self.admin_email
    Settings.not_found_symbol          = self.not_found_symbol
    Settings.not_scanned_symbol        = self.not_scanned_symbol
    Settings.default_time_format       = self.default_time_format
    Time::DATE_FORMATS[:default]       = Settings.default_time_format
    return true
  end


end
