Veggie::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  require 'sidekiq/web'
  constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.admin? }
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :members, :controllers => {
   :omniauth_callbacks => :authentications,
   :sessions => :sessions
  }

  # olive
  match "o" => "olive#index", :as => :olive
  namespace :olive do
    get 'courses'
    get 'quotes'
    get 'persons'
    
    post 'create_quote'
    post 'destroy_tag'
  end

  namespace :courses do
    post 'update'
    post 'ready'
    post 'open'
    post 'destroy'
  end

  namespace :words do
    post 'fetch'
  end
  
  # members
  match "account" => "members#index"
  match "achieve" => "members#index"
  match "genius" => "members#index"
  namespace :members do
    post "update"
    post "upload_avatar"
    get "dashboard"
    get "account"
    get "genius"
    get "friend"
  end
  match ":role/:uid" => "members#show" 
  
  authenticated :member do
    root :to => "members#index"
  end
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
