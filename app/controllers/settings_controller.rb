class SettingsController < ApplicationController
  respond_to :html

  def index
    authorize! :read, SettingsForm
    @settings = SettingsForm.load_current
    respond_with @settings
  end

  def update
    @settings = SettingsForm.new(settings_params)
    authorize! :update, SettingsForm
    respond_to do |format|
      if @settings.valid?
        @settings.update
        flash[:notice] = 'Settings was successfully updated.'
        format.html { render :action => "index" }
      else
        flash[:notice] = nil
        format.html { render :action => "index" }
      end
    end
  end

  def settings_params
    params.require(:settings_form).permit(:admin_email, :not_found_symbol, :not_scanned_symbol, :antigate_key,
      :default_time_format, :crawler_http_open_timeout, :crawler_http_read_timeout, :crawler_interfaces)
  end

end
