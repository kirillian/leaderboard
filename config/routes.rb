Rails.application.routes.draw do
  # Frontend Routing
  resources :entities

  # api.leaderboard.com/v1/:resource
  namespace :api, constraints: {subdomain: 'api'} do
    namespace :v1, defaults: { format: :json } do
      resources :entities, param: :name, path: ""
    end
  end

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :entities, param: :name, path: ""
    end
  end
end
