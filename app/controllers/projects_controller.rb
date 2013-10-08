class ProjectsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    authorize!(:read, @user)
  end

  def scan
    @project  = Project.find(params[:id])
    authorize!(:update, @project)
    if Delayed::Job.enqueue(RankCheckerJob.new(@project.id))
      flash[:notice] = "#{@project.name} report will be created soon."
    else
      flash[:notice] = "Error while scheduling new scan"
    end

    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.js
    end
    
  end

  def show
    redirect_to(edit_project_path(params[:id]))
  end

  def new
    @user = User.find(params[:user_id])
    @project = @user.projects.new
    authorize!(params[:action], @project)
  end

  def edit
    @project  = Project.find(params[:id])
    authorize!(params[:action], @project)

    @keywords = @project.keywords
    @sites    = @project.sites
    @search_engine_ids = @project.search_engine_ids
  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to access invalid project #{params[:id]}")
    flash[:notice] = "Invalid product"
    redirect_to :action => 'index'
  end

  def create
    @user = User.find(params[:user_id])
    @project = Project.new(project_params)
    @project.user_id = @user.id
    authorize!(params[:action], @project)

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(edit_user_project_path(@user, @project)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    params[:project][:search_engine_ids] ||= []
    @project = Project.find(params[:id])
    authorize!(params[:action], @project)
    respond_to do |format|
      if @project.update_attributes(project_params)
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(edit_user_project_path(@project.user_id, @project)) }
      else
        @keywords = @project.keywords
        @sites    = @project.sites
        @search_engine_ids = @project.search_engine_ids
        format.html { render :action => "edit" }
      end
    end
  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to access invalid project #{params[:id]}")
    redirect_to_index("Invalid product")
  end

  def destroy
    @project = Project.find(params[:id])
    authorize!(params[:action], @project)

    @project.destroy

    respond_to do |format|
      flash[:notice] = "Project #{@project.name} was deleted."
      format.html { redirect_to(user_projects_url(@project.user_id)) }
    end
  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to access invalid project #{params[:id]}")
    redirect_to_index("Invalid product")
  end

  def report
    @project = Project.find(params[:id])
    authorize!(:read, @projects)

    @report_group = @project.user.report_groups.find_by_name(@project.name)
    respond_to do |format|
      if @report_group
        session[:selected_report_group_id] = @report_group.id
        session[:flush_reports] = true
        format.html {redirect_to(user_reports_url(@project.user_id))}
      else                                                  
        format.html {redirect_to(user_projects_url(@project.user_id))}
      end
    end
  end

  def project_params
    params.require(:project).permit(:name, :search_depth, :scheduler_mode, 
      :scheduler_factor, :scheduler_day, :scheduler_time, :search_engine_ids => [])
  end

 private

  def redirect_to_index(msg)
    flash[:notice] = msg
    redirect_to :action => 'index'
  end

end
