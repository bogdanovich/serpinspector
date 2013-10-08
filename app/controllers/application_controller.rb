class ApplicationController < ActionController::Base

  before_filter :check_auth, :except => :login
  
  # Apply strong_parameters filtering before CanCan authorization
  # See https://github.com/ryanb/cancan/issues/571#issuecomment-10753675
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  # include all helpers, all the time
  helper :all 
  protect_from_forgery
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :notice => exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_url, :notice => "Malformed URL"
  end

protected
  def current_user
    @current_user = User.find_by_id(session[:user_id])
  end

  def check_auth
    unless current_user
      flash[:notice] = "Please log in"
      redirect_to :controller => 'admin', :action => 'login'
    end
  end
end
