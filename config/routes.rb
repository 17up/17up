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
  
  # members
  match "account" => "members#edit"
  match "achieve" => "members#edit"
  match "genius" => "members#edit"
  namespace :members do
    post "update"
    post "upload_avatar"
    get "account"
    get "genius"
    get "achieve"
  end
  match ":role/:uid" => "members#show" 
  
  authenticated :member do
    root :to => "members#dashboard"
  end
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
