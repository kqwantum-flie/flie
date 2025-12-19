Rails.application.routes.draw do
  resources :flie_os, only: [:show] do
    member do
      get :verify
    end
    resources :os_logs, only: [:create]
  end

  root "flie_os#new"
end
