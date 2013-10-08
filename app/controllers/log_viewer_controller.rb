class LogViewerController < ApplicationController
  authorize_resource

  def index
    @log = LogViewer.load
  end


  def update
    @log = LogViewer.new(log_viewer_params)

    respond_to do |format|
      if @log.valid?
        @log.update
        flash[:notice] = 'Log settings were successfully updated.'
        format.js
      else
        flash[:notice] = @log.errors.full_messages.join('<br/>')
        format.js
      end
    end
  end

  def clear
    @log = LogViewer.load
    respond_to do |format|
      if @log.valid?
        @log.clear
        flash[:notice] = @log.file_name + ' was cleaned.'
        format.js { render :action => "update" }
      else
        flash[:notice] = @log.errors.full_messages.join('<br/>')
        p @log
        format.js { render :action => "update" }
      end
    end
  end

  def select_file
    Settings.log_viewer_current_file = params[:file_name] if Settings.log_viewer_available_files.include?(params[:file_name])
    @log = LogViewer.load
    
    respond_to do |format|
      flash[:notice] = @log.file_name + ' was selected.'
      format.js { render :action => "update" }
    end
  end

  def log_viewer_params
    params.require(:log_viewer).permit(:file_name, :content, :height, :refresh_interval, :file_size)
  end

end