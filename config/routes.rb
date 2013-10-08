SERPInspector::Application.routes.draw do

  resources :search_engines

  resources :users do
    resources :projects do
      resources :keywords
      resources :sites
      member do
        get :scan
        get :report
      end
    end

    resources :report_groups, :only => [:index] do
      member do
        get :last_report
        get :graph
      end
      get :refresh, :on => :collection
    end

    resources :reports, :only => [:index] do
      collection do
        post :on_report_change
        post :on_report_group_destroy
        post :on_report_destroy
        post :on_report_group_change
        post :on_show_limit_change
        post :on_report_group_sort
        post :on_report_group_move_up
        post :on_report_group_move_down
      end
    end

    get :welcome, :on => :collection
    get :go_reports, :on => :member
  end

  resources :log_viewer, :only => [:index] do
    collection do
      post   :update
      get    :select_file
      delete :clear
    end
  end

  resource :settings, :only => [:index] do
    get  :index
    post :update, :on => :member
  end

  match '/admin/login',  :to => 'admin#login',  :via => [:get, :post]
  match '/admin/logout', :to => 'admin#logout', :via => [:get, :post]

  root :to => 'users#welcome'
end