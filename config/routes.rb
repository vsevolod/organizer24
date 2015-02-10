Organizer::Application.routes.draw do

  devise_for :user_admins
  #mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  mount Ckeditor::Engine => '/ckeditor'

  constraints(Subdomain) do

    namespace :api, defaults: {format: :json} do
      resources :workers
      #resources :services
      resources :services_users
    end

    root :to => 'organizations#show'

    match '/dashboard', :to => 'users#dashboard', as: 'dashboard'
    match '/calendar' => 'organizations#calendar', :as => :calendar
    match '/edit'=> 'organizations#edit', :as => :edit
    match '/modal'=> 'organizations#modal', :as => :modal
    match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

    resources :appointments do
      resources :services_users do
        collection do
          put :update_services
        end
      end
      collection do
        get :by_week
        get :phonebook
        post :update_all
      end
      member do
        post :change_status
        post :change_params
      end
    end
    resources :category_photos do
      resources :photos
    end
    resources :notifications, only: [:index] do
      collection do
        get :sms
        post :change_sms
      end
    end
    resources :codes, except: [:show]
    resources :working_hours, :only => [:show] do
      collection do
        get :self_by_month
      end
    end
    resources :workers do
      member do
        get :services_workers
      end
      resources :double_rates do
        collection do
          get :by_week
        end
      end
      resources :working_hours do
        collection do
          get :by_week
        end
      end
      resources :working_days do
        collection do
          post :inverse_day
        end
      end
    end
    resources :pages, :except => [:show]
    resources :services do
      collection do
        post :sort_services
        get  :statistic
      end
    end
    resources :dictionaries
    get ':id', :to => 'pages#show'
  end

  resources :after_signup

  root :to => 'main#index'
  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions", :passwords => "passwords", :confirmations => "confirmations" }
  resources :users do
    collection do
      post :check_phone
      post :dashboard
      get  :statistic
    end
    # TODO move to confirmation controller
    member do
      get  :confirm_phone
      post :confirming_phone
      post :resend_confirmation_sms
    end
  end
  resources :organizations, :except => [:show] do
    member do
      get :calendar
      get :modal
    end
  end

  match '/main/set_session' => 'main#set_session', :via => [:get]

end
