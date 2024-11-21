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

    resources :schools, only: %i[index show], param: :urn do
    end

    resources :teachers, only: %i[index show] do
    end
  end

  resource :appropriate_bodies, only: %i[show], path: 'appropriate-body', as: 'ab_landing', controller: 'appropriate_bodies/landing'
  namespace :appropriate_bodies, path: 'appropriate-body', as: 'ab' do
    resources :teachers, only: %i[show index], controller: 'teachers', param: 'trn' do
      resource :release_ect, only: %i[new create show], path: 'release', controller: 'teachers/release_ect'
      resource :record_outcome, only: %i[new create show], path: 'record-outcome', controller: 'teachers/record_outcome'
    end

    namespace :claim_an_ect, path: 'claim-an-ect' do
      resource :find_ect, only: %i[new create], path: 'find-ect', controller: '/appropriate_bodies/claim_an_ect/find_ect', as: 'find'
      resources :check_ect, only: %i[edit update], path: 'check-ect', controller: '/appropriate_bodies/claim_an_ect/check_ect', as: 'check'
      resources :register_ect, only: %i[edit update show], path: 'register-ect', controller: '/appropriate_bodies/claim_an_ect/register_ect', as: 'register'

      namespace :errors do
        get 'induction-already-completed/:id', to: '/appropriate_bodies/claim_an_ect/errors#induction_already_completed', as: 'already_complete'
        get 'induction-with-another-appropriate-body/:id', to: '/appropriate_bodies/claim_an_ect/errors#induction_with_another_appropriate_body', as: 'another_ab'
        get 'no-qts/:id', to: '/appropriate_bodies/claim_an_ect/errors#no_qts', as: 'no_qts'
        get 'prohibited-from-teaching/:id', to: '/appropriate_bodies/claim_an_ect/errors#prohibited_from_teaching', as: 'prohibited'
        get 'exempt/:id', to: '/appropriate_bodies/claim_an_ect/errors#exempt', as: 'exempt'
        get 'completed/:id', to: '/appropriate_bodies/claim_an_ect/errors#completed', as: 'completed'
      end
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

    resource :register_ect, path: "register-ect", only: %i[] do
      collection do
        get "what-you-will-need", action: :start, as: :start
        get "find-ect", action: :new
        post "find-ect", action: :create
        get "national-insurance-number", action: :new
        post "national-insurance-number", action: :create
        get "not-found", action: :new
        get "review-ect-details", action: :new
        post "review-ect-details", action: :create
        get "email-address", action: :new
        post "email-address", action: :create
        get "check-answers", action: :new
        post "check-answers", action: :create
        get "confirmation", action: :new
      end
    end
  end
end
