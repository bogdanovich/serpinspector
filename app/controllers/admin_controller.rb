class AdminController < ApplicationController
  skip_authorization_check
  def login
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        session[:user_name] = user.name
        redirect_to root_path, :notice => "Welcome, #{user.name}"
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    reset_session
    flash[:notice]    = "Logged out"
    redirect_to :action => 'login'
  end

end
