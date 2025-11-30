Rails.application.routes.draw do
  devise_for :users
  # Admin authentication and dashboard
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Products
  resources :products

  # Root path
  root "products#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Cart routes
  get  "cart",               to: "cart#show",    as: "cart"
  post "cart/add/:id",       to: "cart#add",     as: "cart_add"
  post "cart/remove/:id",    to: "cart#remove",  as: "cart_remove"
  post "cart/clear",         to: "cart#clear",   as: "cart_clear"

  # Quantity controls
  post "cart/increase/:id",  to: "cart#increase", as: "cart_increase"
  post "cart/decrease/:id",  to: "cart#decrease", as: "cart_decrease"
end
