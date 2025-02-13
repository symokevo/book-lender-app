Rails.application.routes.draw do
  root "books#index"
  resources :books
  resource :registration, only: %i[new create]
  resource :dashboards, only: :show
  resource :session, only: %i[new create destroy]
  get "up" => "rails/health#show", as: :rails_health_check
end
