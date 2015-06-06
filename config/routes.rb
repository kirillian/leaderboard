require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  root 'entities#index'

  # Frontend Routing
  resources :entities, only: [:index]

  # api.leaderboard.com/v1/:resource
  namespace :api, constraints: { subdomain: 'api' } do
    namespace :v1, defaults: { format: :json } do
      resources :entities, param: :name, path: ''
    end
  end

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :entities, param: :name, path: ''
    end
  end
end
