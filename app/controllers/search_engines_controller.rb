class SearchEnginesController < ApplicationController
  load_and_authorize_resource

  def index

  end

  def show

  end

  def new

  end

  def edit

  end

  def create
    respond_to do |format|
      if @search_engine.save
        flash[:notice] = 'SearchEngine was successfully created.'
        format.html { redirect_to(search_engines_url) }
        format.xml  { render :xml => @search_engine, :status => :created, :location => @search_engine }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @search_engine.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @search_engine.update_attributes(search_engine_params)
        flash[:notice] = 'SearchEngine was successfully updated.'
        format.html { redirect_to(search_engines_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @search_engine.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @search_engine.destroy

    respond_to do |format|
      flash[:notice] = "SearchEngine #{@search_engine.name} was deleted."
      format.html { redirect_to(search_engines_url) }
      format.xml  { head :ok }
    end
  end

  def search_engine_params
    params.require(:search_engine).permit(:name, :main_url, :query_input_selector, :item_regex, 
      :next_page_selector, :next_page_delay, :version, :active)
  end
end
