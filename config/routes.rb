Organizer::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  constraints(Subdomain) do
    root :to => 'organizations#show'

    match '/calendar' => 'organizations#calendar', :as => :calendar
    match '/edit'=> 'organizations#edit', :as => :edit
    match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
    match '/dashboard', :to => 'users#dashboard'

    resources :appointments do
      collection do
        get :by_week
      end
      member do
        post :change_status
        post :change_start_time
      end
    end
    resources :category_photos
    resources :executors
    resources :pages, :except => [:show]
    resources :services
    resources :working_hours do
      collection do
        get :by_week, :self_by_month
      end
    end
    get ':id', :to => 'pages#show'
  end

  match '/dashboard', :to => 'users#dashboard'
  root :to => 'main#index'
  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }
  resources :users
  resources :organizations, :except => [:show] do
    member do
      get :calendar
    end
  end

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

end
