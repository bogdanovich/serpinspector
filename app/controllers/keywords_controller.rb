class KeywordsController < ApplicationController

  def create
    authorize!(:update, Project.find(params[:project_id]))
    @keyword = Keyword.new(keyword_params)
    @keyword.project_id = params[:project_id]
    respond_to do |format|
      if @keyword.save
        flash[:notice] = 'Keyword was successfully added.'
        format.html { redirect_to(edit_project_url(params[:project_id])) }
        format.js
      else
        flash[:notice] = 'Keyword already exists!'
        format.js { render 'error' }
      end
    end
  end

  def destroy
    authorize!(:update, Project.find(params[:project_id]))
    @keyword = Keyword.find(params[:id])
    @keyword.destroy
    respond_to do |format|
      flash[:notice] = 'Keyword was successfully deleted.'
      format.html { redirect_to(edit_project_url(params[:project_id])) }
      format.js
    end
  end

  def keyword_params
    params.require(:keyword).permit(:name)
  end
end
