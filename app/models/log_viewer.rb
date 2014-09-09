class LogViewer
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :file_name, :content, :height, :refresh_interval, :file_size, :existing_files

  validates_presence_of :file_name, :height
  validates_inclusion_of :height, :in => 1..10000, :message => "can only be between 1 and 10000"
  validates_inclusion_of :file_name, :in => Settings.defaults[:log_viewer_available_files], :message => "invalid filename"

  def initialize(attributes={})
   attributes && attributes.each do |name, value|
     send("#{name}=", value) if respond_to? name.to_sym
     @height = @height.to_i 
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

  def self.existing_files
    Settings.log_viewer_available_files.select { |file_name| File.exists?(Rails.root.join('log', file_name)) }
  end 


  def update
    Settings.log_viewer_current_file     = self.file_name
    Settings.log_viewer_height           = self.height
    Settings.log_viewer_refresh_interval = self.refresh_interval
    self.content   = LogViewer.load_log(self.file_name, self.height)
    self.file_size = LogViewer.load_size(self.file_name)
  end

  def clear
    File.open(Rails.root.join('log', self.file_name), "w") { |file| file.puts "" }
    self.content   = ""
    self.file_size = LogViewer.load_size(self.file_name)
  end

  def self.load
    file_name = Settings.log_viewer_current_file
    height    = Settings.log_viewer_height
    return LogViewer.new(:file_name => file_name,
                         :height => height,
                         :refresh_interval => Settings.log_viewer_refresh_interval,
                         :content => load_log(file_name, height),
                         :file_size => load_size(file_name))
  end

  def self.load_file_name(file_name)
    file_name = Settings.log_viewer_current_file
    height    = Settings.log_viewer_height
    return LogViewer.new(:file_name => file_name,
                         :height => height,
                         :refresh_interval => Settings.log_viewer_refresh_interval,
                         :content => load_log(file_name, height),
                         :file_size => load_size(file_name))
  end

  def self.load_size(file_name)
    size = File.size(Rails.root.join('log', file_name))
    (size / 1024).to_s + ' kB'
  end

  def self.load_log(file_name, height)
    path    = Rails.root.join('log', file_name)
    content = ""
    File::Tail::Logfile.tail(path, :backward => height, :return_if_eof => true) do |line|
        content << line
    end
    content
  end

end
