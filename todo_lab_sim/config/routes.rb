Rails.application.routes.draw do
  resources :todos

  get "/lab", to: "lab#show"
  post "/lab/toggle", to: "lab#toggle"

  root "todos#index"
end
