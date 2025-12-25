Rails.application.routes.draw do
  resources :flie_os, only: [:show] do
    member do
      get :verify
      get :"ted/#{Aos::Os::STAR}filepath".to_s, to: :"flie_os#ted".to_s, as: :flie_os_ted.to_s
      get :"html/#{Aos::Os::STAR}filepath".to_s, to: :"flie_os#html".to_s, as: :flie_os_html.to_s
    end
    resources :os_logs, only: [:create]
    resources :tbufs, only:[:update]
  end

  root :"flie_os#new".to_s
end
