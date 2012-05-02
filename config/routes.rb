Organizer::Application.routes.draw do
  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  root :to => 'pages#index'
  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :pages
  resources :organizations

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

end
