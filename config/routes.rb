Rails.application.routes.draw do
  # Frontend Routing
  resources :entities

  # api.leaderboard.com/v1/:resource
  namespace :api, path: "", constraints: {subdomain: 'api'} do
    namespace :v1, defaults: { format: :json } do
      resources :entities, param: :name
    end
  end
end
