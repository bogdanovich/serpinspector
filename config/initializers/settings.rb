
Settings.defaults[:admin_email]                 = 'default@serpinspector.com'
Settings.defaults[:not_found_symbol]            = '-'
Settings.defaults[:not_scanned_symbol]          = '?'
Settings.defaults[:default_time_format]         =  "%d.%m.%Y %H:%M:%S %Z"
Settings.defaults[:log_viewer_available_files]  = ["delayed_job.log", "production.log", "development.log"]
Settings.defaults[:log_viewer_current_file]     = 'development.log'
Settings.defaults[:log_viewer_height]           = 500
Settings.defaults[:log_viewer_refresh_interval] = 30
Settings.defaults[:log_viewer_autorefresh]      = false
Settings.defaults[:reports_show_limit]          = 15
Settings.defaults[:overview_updated_at]         = Time.now
Settings.defaults[:crawler_user_agents_file]    = 'config/user_agents.txt'
Settings.defaults[:reports_show_limits]         = [['last 5', '5'], ['last 15', '15'], ['last 30', '30'], ['last 60', '60'], 
                                                  ['last 180', '180'], ['last 360', '360'], ['All', '0']]
Settings.defaults[:user_roles_available]        = ['user', 'admin']



begin
  Time::DATE_FORMATS[:default] = Settings.default_time_format
rescue # settings table do not exists (when rake db:migrate)
  Time::DATE_FORMATS[:default] = Settings.defaults[:default_time_format]
end
