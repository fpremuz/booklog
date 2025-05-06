Rails.application.routes.draw do
  get "pages/home"
  get "users/new"
  get "users/create"
  get "users/show"
  resource :session
  resources :passwords, param: :token
  resources :users, only: [:new, :create, :show, :edit, :update]
  resources :books do
    member do
      patch :update_progress
    end
  end

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  root "pages#home"
end
