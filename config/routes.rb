Rails.application.routes.draw do
  resources :flie_os, only: [:show] do
    resources :os_logs, only: [:create]
  end

  root "flie_os#new"

  # resources :users
  # resource :session
  # resources :passwords, param: :token
end
