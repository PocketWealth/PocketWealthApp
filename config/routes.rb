Rails.application.routes.draw do
  # <=== Custom Paths ===>
  # <=== Sessions ===>
  get  "/login",  to: "sessions#new"
  post "/login",  to: "sessions#create"
  get "sessions/new"
  delete "/logout", to: "sessions#destroy"
  # <=== Users ===>
  get "/signup",  to: "users#new"
  # <=== Accounts ===>
  get "/home",  to: "accounts#index"
  get "/accounts/:id/edit_cash",  to: "accounts#edit_cash", as: "account_edit_cash"
  patch "/accounts/:id/edit_cash",  to: "accounts#update_edit_cash", as: "account_update_edit_cash"
  # <=== Stocks ===>
  get "/stocks/:id/delete",  to: "stocks#delete"


  # <=== Resources ===>
  resources :api_keys
  resources :users
  resources :accounts
  resources :registered_account_limits
  resources :stocks


  # <=== Root Path ===>
  root "accounts#index"

  # <=== Boilerplate ===>
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
