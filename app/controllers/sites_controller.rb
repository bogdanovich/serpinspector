class SitesController < ApplicationController

  def create
    authorize!(:update, Project.find(params[:project_id]))
    @site = Site.new(site_params)
    @site.project_id = params[:project_id]
    respond_to do |format|
      if @site.save
        flash[:notice] = 'Url was successfully added.'
        format.html { redirect_to(edit_project_url(params[:project_id])) }
        format.js
      else
        flash[:notice] = 'Url already exists!'
        format.js { render 'keywords/error' }
      end
    end
  end

  def destroy
    authorize!(:update, Project.find(params[:project_id]))
    @site = Site.find(params[:id])
    @site.destroy
    respond_to do |format|
      flash[:notice] = 'Url was successfully deleted.'
      format.html { redirect_to(edit_project_url(params[:project_id])) }
      format.js
    end
  end

  def site_params
    params.require(:site).permit(:name)
  end
end
