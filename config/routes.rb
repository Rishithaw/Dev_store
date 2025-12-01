Rails.application.routes.draw do
  get "checkout/index"
  get "checkout/invoice"
  get "checkout/complete"
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

  resource :checkout, only: [] do
    get :address
    post :address
    get :invoice
    post :complete
  end

  get "checkout", to: "checkout#index"
  post "checkout/confirm", to: "checkout#confirm"
  post "checkout/complete", to: "checkout#complete"


end
