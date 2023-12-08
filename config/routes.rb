require 'sidekiq/web'
require 'sidekiq/cron/web'
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # get 'admins/index'
  # get 'admins/create'
  # get 'managers/index'
  # get 'managers/create'
  # get 'users/index'
  # get 'users/create'
  # resources :users
  # resources :comments
  # resources :tasks
  resources :users do
    resources :tasks do
      resources :comments
    end
  end
  mount Sidekiq::Web => '/sidekiq'
  post 'task/assign', to: 'tasks#assign_task'
  post 'login', to: 'authentication#login'
  get '/auth/google_oauth2/callback', to: 'users#google_oauth2_callback'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
