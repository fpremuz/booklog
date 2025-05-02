Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :books

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  root "books#index"
end
