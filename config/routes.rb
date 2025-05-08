Rails.application.routes.draw do
  get "analytics", to: "analytics#index"

  get "pages/home"

  get "users/new"
  get "users/create"
  get "users/show"

  get "profiles/show"
  get "/profiles/:username", to: "profiles#show", as: :profile
  get "/profiles/:username/edit", to: "profiles#edit", as: :edit_profile
  get "/profiles/:username/share", to: "profiles#share", as: :share_profile
  patch "/profiles/:username", to: "profiles#update", as: :update_profile

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  resource :session
  resources :passwords, param: :token
  resources :users, only: [:new, :create, :show, :edit, :update]
  resources :profiles, only: [:show, :edit, :update]
  resources :books do
    member do
      patch :update_progress
    end

    collection do
      get :export_pdf
    end
  end  

  root "pages#home"
end
