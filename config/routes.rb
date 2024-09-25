ROLE_TYPE_CONSTRAINT_RE = Regexp.new(Admin::RolesForm::ROLE_TYPES.join('|'))

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

  namespace :admin do
    resources :users, only: %i[index] do
      member do
        get '/roles', to: 'roles#index', as: :role_type
        get '/:role_type', to: 'roles#edit', constraints: { role_type: ROLE_TYPE_CONSTRAINT_RE }, as: :roles
        put '/:role_type', to: 'roles#update', constraints: { role_type: ROLE_TYPE_CONSTRAINT_RE }
      end
    end
  end

  resource :appropriate_bodies, only: %i[show], path: 'appropriate-body', as: 'ab' do
    namespace :claim_an_ect, path: 'claim-an-ect' do
      resource :find_ect, only: %i[new create], path: 'find-ect', controller: '/appropriate_bodies/claim_an_ect/find_ect', as: 'find'
      resources :check_ect, only: %i[edit update], path: 'check-ect', controller: '/appropriate_bodies/claim_an_ect/check_ect', as: 'check'
      resources :register_ect, only: %i[edit update show], path: 'register-ect', controller: '/appropriate_bodies/claim_an_ect/register_ect', as: 'register'
    end
  end

  scope module: "migration" do
    resources :migrations, only: %i[index create] do
      get "download_report/:model", on: :collection, action: :download_report, as: :download_report
      post "reset", on: :collection, action: :reset, as: :reset
    end
  end
end
