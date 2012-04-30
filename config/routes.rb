Organizer::Application.routes.draw do
  root :to => 'pages#index'
  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :pages
  resources :organizations

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

end
