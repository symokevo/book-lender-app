Rails.application.routes.draw do
  root "books#index"
  resources :books
  resource :dashboards, only: :show
  get "up" => "rails/health#show", as: :rails_health_check
end
