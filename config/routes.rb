Rails.application.routes.draw do
  root "books#index"
  resources :books
  resource :registration, only: %i[new create]
  resource :dashboards, only: :show
  get "up" => "rails/health#show", as: :rails_health_check
end
