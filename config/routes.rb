require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :user_admins
  # mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  mount Ckeditor::Engine => '/ckeditor'
  mount API::Root => '/'

  # Sidekiq
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(username, ENV["organizer"]) &
      ActiveSupport::SecurityUtils.secure_compare(password, ENV["123321"])
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'

  constraints(Subdomain) do
    namespace :api, defaults: { format: :json } do
      resources :workers
      # resources :services
      resources :services_users
      resources :appointments
    end

    get '/', to: 'organizations#show'

    get '/dashboard', to: 'users#dashboard', as: 'dashboard'
    get '/calendar' => 'organizations#calendar', :as => :calendar
    get '/edit' => 'organizations#edit', :as => :edit
    get '/modal' => 'organizations#modal', :as => :modal
    get '/calendar(/:year(/:month))' => 'calendar#index', :as => :date_calendar, :constraints => { year: /\d{4}/, month: /\d{1,2}/ }

    resource :telegram_user, only: [:new, :create, :show]

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
        get :send_sms
        post :change_sms
      end
    end
    resources :codes, except: [:show]
    resources :working_hours, only: [:show] do
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
          post :clear_all
          post :inverse_day
        end
      end
    end
    resources :pages, except: [:show]
    resources :services do
      collection do
        post :sort_services
        get  :statistic
      end
    end
    resources :dictionaries
    get '/:id', to: 'pages#show'
  end

  resources :after_signup

  root to: 'main#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }
  resources :users do
    collection do
      post :check_phone
      post :dashboard
      get  :statistic
    end
    # TODO: move to confirmation controller
    member do
      get  :confirm_phone
      post :confirming_phone
      post :resend_confirmation_sms
    end
  end
  resources :organizations, except: [:show] do
    member do
      get :calendar
      get :modal
    end
  end

  get '/main/set_session' => 'main#set_session'
end
