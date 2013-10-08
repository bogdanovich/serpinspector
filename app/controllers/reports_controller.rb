class ReportsController < ApplicationController

  def index
    session[:flush_reports] = true
    prepare_report_groups
    authorize!(:read, @user)
    prepare_report
    if @report_groups.empty?
      flash.now[:notice] = 'You have no reports yet!'
      render 'users/welcome'
    end
  end

  def on_report_group_change
    @selected_report_group = selected_report_group
    authorize!(:read, @selected_report_group)
    @reports               = find_reports
    prepare_report
  end

  def on_show_limit_change
    cookies.permanent[:reports_show_limit] = params[:report][:show_limit] unless Settings.reports_show_limits.rassoc(params[:report][:show_limit]).nil?
    prepare_report_groups
    authorize!(:read, @user)
    prepare_report
    respond_to do |format|
      format.js { render :action => "on_report_group_change" }
    end
  end

  def on_report_change
    @selected_report_group = selected_report_group
    authorize!(:read, @selected_report_group)
    @selected_report       = selected_report
  end

  def on_report_group_destroy
    begin
      report_group = ReportGroup.find(params[:report][:report_group_id])
      authorize!(:destroy, report_group)
      report_group.destroy
    rescue ActiveRecord::RecordNotFound
      logger.info "Report group delete error: record not found"
    end
    session[:flush_report_groups] = session[:flush_reports] = true
    prepare_report_groups
    prepare_report
    flash.now[:notice] = 'Report group was deleted!'
  end

  def on_report_destroy
    begin
      report = Report.find(params[:report][:id])
      authorize!(:read, report.report_group)
      report.destroy
    rescue ActiveRecord::RecordNotFound
      logger.info "Report delete error: record not found"
    end
    @selected_report_group  = selected_report_group
    @reports                = find_reports
    session[:flush_reports] = true
    prepare_report
    flash.now[:notice] = 'Report was deleted!'
  end

  def prepare_report_groups
    @user          = User.find(params[:user_id]) unless @user
    @report_groups = @user.report_groups.order('display_order') unless @report_groups
    if @report_groups.empty?
      @selected_report_group        = ReportGroup.new
      session[:selected_report_group_id] = nil
      @reports = []
    else
      @selected_report_group        = selected_report_group
    end
  end

  def prepare_report
    @reports = find_reports
    if @reports.empty?
      @reports = [Report.new]
      @selected_report = Report.new
      session[:selected_report_id] = nil
    else
      @selected_report       = selected_report
    end
  end

  def selected_report_group
    # init session
    session[:selected_report_group_id] = @report_groups.first.id unless session.has_key?(:selected_report_group_id)
    if session[:flush_report_groups]
      session[:selected_report_group_id] = @report_groups.first.id
      session[:flush_report_groups]      = false
    elsif params.has_key?(:report) and params[:report].has_key?(:report_group_id) and session[:selected_report_group_id] != params[:report][:report_group_id].to_i
      session[:flush_reports] = true
      session[:selected_report_group_id] = params[:report][:report_group_id].to_i
    end
    ReportGroup.find(session[:selected_report_group_id])
  end

  def selected_report
    #init session 
    session[:selected_report_id] = @reports.first.id unless session.has_key?(:selected_report_id)
    if session[:flush_reports]
      session[:selected_report_id] = @reports.first.id
      session[:flush_reports] = false
    elsif params.has_key?(:report) and params[:report].has_key?(:id) and session[:selected_report_id] != params[:report][:id].to_i
      session[:selected_report_id] = params[:report][:id].to_i
    end
    Report.find(session[:selected_report_id])
  end

  def find_reports
    show_limit = (cookies[:reports_show_limit].nil?) ?  Settings.reports_show_limit : cookies[:reports_show_limit]
    if show_limit.to_i > 0
      return Report.where(:report_group_id => @selected_report_group.id).order('created_at desc').limit(show_limit)
    else
      return Report.where(:report_group_id => @selected_report_group.id).order('created_at desc')
    end
  end

  def on_report_group_sort
    @user = User.find(params[:user_id])
    @report_groups = @user.report_groups.order('name')
    authorize!(:update, @report_groups.first)
    @report_groups.each_with_index { |rg, ind|
      rg.display_order = ind
      rg.save
    }

    session[:flush_report_groups] = session[:flush_reports] = true
    prepare_report_groups
    prepare_report
  end

  def on_report_group_move_up
    @user = User.find(params[:user_id])
    report_group = ReportGroup.find(params[:report][:report_group_id])
    authorize!(:update, report_group)
    result_groups = ReportGroup.where(:user_id => @user.id, :display_order => report_group.display_order).order("display_order DESC").limit(1)

    unless result_groups.empty?
      report_group_to_swap = result_groups.first
      tmp = report_group.display_order
      report_group.display_order = report_group_to_swap.display_order
      report_group_to_swap.display_order = tmp
      report_group_to_swap.save
      report_group.save
    end

    prepare_report_groups
  end

  def on_report_group_move_down
    @user = User.find(params[:user_id])
    report_group = ReportGroup.find(params[:report][:report_group_id])
    authorize!(:update, report_group)
    result_groups = ReportGroup.where(:user_id => @user.id, :display_order => report_group.display_order).order("display_order").limit(1)

    unless result_groups.empty?
      report_group_to_swap = result_groups.first
      tmp = report_group.display_order
      report_group.display_order = report_group_to_swap.display_order
      report_group_to_swap.display_order = tmp
      report_group_to_swap.save
      report_group.save
    end

    prepare_report_groups
  end
end
