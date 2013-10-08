class UsersController < ApplicationController
  load_and_authorize_resource :except => :welcome
  skip_authorization_check :only => :welcome

  def index

  end

  def show

  end

  def new

  end

  def edit

  end

  def welcome

  end

  def create

    respond_to do |format|
      if @user.save
        flash[:notice] = "User #{@user.name} was successfully created."
        format.html { redirect_to(:action => 'index') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :update_name, @user if params[:user][:name]
    authorize! :update_role, @user if params[:user][:role]

    respond_to do |format|
      if @user.update_attributes(user_params)
       flash[:notice] = "User #{@user.name} was successfully updated."
        format.html { redirect_to(:action => 'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      flash[:notice] = "User #{@user.name} was deleted."
      format.html { redirect_to(users_url) }
    end
  end

  def go_reports
    session[:flush_report_groups] = true

    respond_to do |format|
      format.html { redirect_to user_reports_url(@user) }
    end
  end

  def user_params
    params.require(:user).permit(:name, :role, :password, :password_confirmation)
  end

end
