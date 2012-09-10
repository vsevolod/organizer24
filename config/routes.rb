Organizer::Application.routes.draw do
  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  match '/dashboard', :to => 'users#dashboard'

  root :to => 'pages#index'
  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :pages
  resources :users
  resources :organizations do
    resources :appointments do
      collection do
        get :by_week
      end
      member do
        post :change_status
      end
    end
    resources :working_hours do
      collection do
        get :by_week
      end
    end
    resources :executors
    resources :services
    member do
      get :calendar
    end
  end

  resources :appointments

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

end
