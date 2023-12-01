Rails.application.routes.draw do
  # get 'admins/index'
  # get 'admins/create'
  # get 'managers/index'
  # get 'managers/create'
  # get 'users/index'
  # get 'users/create'
  resources :users
  resources :comments
  resources :tasks
  post 'login', to: 'authentication#login'
  get '/auth/google_oauth2/callback', to: 'users#google_oauth2_callback'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
