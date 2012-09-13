Organizer::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  match '/dashboard', :to => 'users#dashboard'

  root :to => 'main#index'
  devise_for :users, :controllers => { :registrations => "registrations" }

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
    resources :category_photos
    resources :executors
    resources :pages, :except => [:show]
    resources :services
    member do
      get :calendar
    end
    resources :working_hours do
      collection do
        get :by_week
      end
    end
  end
  get '/organizations/:organization_id/:id', :to => 'pages#show'

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

end
