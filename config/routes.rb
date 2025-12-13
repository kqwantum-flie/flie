Rails.application.routes.draw do
  resources :flie_os, only: [:show] do
    resources :os_logs, only: [:create]
  end
  # resources :users
  # resource :session
  # resources :passwords, param: :token

  root "flie_os#new"
end
