Rails.application.routes.draw do
  resources :users, only: %i[new create]
  resource :session, only: %i[new create destroy]

  resources :todos
  get "/error", to: "errors#not_found"

  get "/lab", to: "lab#show"
  post "/lab/toggle", to: "lab#toggle"

  root "sessions#new"
end
