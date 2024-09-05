Rails.application.routes.draw do
  root to: 'pages#home'
  get "healthcheck" => "rails/health#show", as: :rails_health_check

  scope via: :all do
    get '/404', to: 'errors#not_found'
    get '/422', to: 'errors#unprocessable_entity'
    get '/429', to: 'errors#too_many_requests'
    get '/500', to: 'errors#internal_server_error'
  end

  resources :cities, only: %i[index create show]
  resources :countries, only: %i[index create show]

  # omniauth sign-in
  get 'auth/:provider/callback', to: 'sessions#create'
  get '/sign-in', to: 'sessions#new'
  get '/sign-out', to: 'sessions#destroy'

  # one time password
  get '/otp-sign-in', to: 'otp_sessions#new'
  post '/otp-sign-in', to: 'otp_sessions#create'
  get '/otp-sign-in/code', to: 'otp_sessions#request_code'
  post '/otp-sign-in/verify', to: 'otp_sessions#verify_code'

  # TODO: Add constraint to prevent personas working in production environment
  get 'personas', to: 'personas#index'
  post 'auth/:provider/callback', to: 'sessions#create'

  get '/admin', to: 'admin#index'
end
