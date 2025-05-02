Rails.application.routes.draw do
  get "users/new"
  get "users/create"
  get "users/show"
  resource :session
  resources :passwords, param: :token
  resources :books
  resources :users, only: [:new, :create, :show]

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  root "books#index"
end
