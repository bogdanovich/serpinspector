class ReportGroupsController < ApplicationController

  skip_authorization_check :only => [:refresh, :index]
  
  def index
    @user = User.find(params[:user_id]) unless @user
    authorize!(:read, @user)
  end

  def refresh
    authorize!(:read, @user)
    expire_fragment 'overview'
    redirect_to :action => :index
  end

  def last_report
    @report_group = ReportGroup.find(params[:id])
    authorize!(:read, @report_group)
    respond_to do |format|
      if @report_group
        session[:selected_report_group_id] = @report_group.id
        session[:flush_reports] = true
        format.html {redirect_to(user_reports_url(@report_group.user_id))}
      else
        format.html {redirect_to(user_projects_url(@report_group.user_id))}
      end
    end
  end

  def graph
    @report_group = ReportGroup.find(params[:id])
    authorize!(:read, @report_group)
    @site_url = params[:site_url]
    @keyword = params[:keyword]
    @search_engine = params[:search_engine]
    @positions_dataset = ReportItem.js_for_plot(@site_url, @keyword, @search_engine)
  end

end
