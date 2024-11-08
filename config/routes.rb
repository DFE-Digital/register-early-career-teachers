Rails.application.routes.draw do
  root to: 'pages#home'
  get '/support', to: 'pages#support'

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

  constraints -> { Rails.application.config.enable_personas } do
    resources 'personas', only: %i[index] do
      collection do
        resource :appropriate_body_sessions, only: %i[show update], controller: 'personas/appropriate_body_sessions', path: 'appropriate-body-sessions'
      end
    end
  end

  post 'auth/:provider/callback', to: 'sessions#create'

  get '/admin', to: 'admin#index'

  namespace :admin do
    resources :users, only: %i[index] do
    end

    resources :appropriate_bodies, only: %i[index], path: 'appropriate-bodies' do
    end

    resources :teachers, only: %i[index show] do
    end
  end

  resource :appropriate_bodies, only: %i[show], path: 'appropriate-body', as: 'ab' do
    collection do
      resources :teachers, only: %i[show], controller: 'appropriate_bodies/teachers', as: 'ab_teachers', param: 'trn' do
        resource :release_ect, only: %i[new create show], path: 'release', controller: 'appropriate_bodies/teachers/release_ect'
        resource :record_outcome, only: %i[new create show], path: 'record-outcome', controller: 'appropriate_bodies/teachers/record_outcome'
      end
    end
    namespace :claim_an_ect, path: 'claim-an-ect' do
      resource :find_ect, only: %i[new create], path: 'find-ect', controller: '/appropriate_bodies/claim_an_ect/find_ect', as: 'find'
      resources :check_ect, only: %i[edit update], path: 'check-ect', controller: '/appropriate_bodies/claim_an_ect/check_ect', as: 'check'
      resources :register_ect, only: %i[edit update show], path: 'register-ect', controller: '/appropriate_bodies/claim_an_ect/register_ect', as: 'register'
    end
  end

  namespace :migration do
    resources :migrations, only: %i[index create], path: "/" do
      collection do
        get ":model/failures", to: "failures#index", as: :failures
        get "download_report/:model", action: :download_report, as: :download_report
        post "reset", action: :reset, as: :reset
      end
    end
    get "teachers/:trn", to: "teachers#show", as: :teacher_details
  end

  namespace :schools do
    get "/home/ects", to: "home#index", as: :ects_home
    get "/what-you-will-need", to: "register_ect#start", as: :register_ect_start

    get "/find-ect", to: "register_ect#new", as: :register_ect_find_ect
    post "/find-ect", to: "register_ect#create"

    get "/review-ect-details", to: "register_ect#new", as: :register_ect_review_ect_details
    post "/review-ect-details", to: "register_ect#create"

    get "/email-address", to: "register_ect#new", as: :register_ect_email_address
    post "/email-address", to: "register_ect#create"

    get "/check-answers", to: "register_ect#new", as: :register_ect_check_answers
    post "/check-answers", to: "register_ect#create"

    get "/confirmation", to: "register_ect#new", as: :register_ect_confirmation
  end
end
