Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :products

  root "products#index"

  get "up" => "rails/health#show", as: :rails_health_check

  get "cart", to: "cart#show", as: "cart"
  post "cart/add/:id", to: "cart#add", as: "cart_add"
  post "cart/remove/:id", to: "cart#remove", as: "cart_remove"
  post "cart/clear", to: "cart#clear", as: "cart_clear"

  post "cart/increase/:id", to: "cart#increase", as: "cart_increase"
  post "cart/decrease/:id", to: "cart#decrease", as: "cart_decrease"
  post "checkout/save_address", to: "checkouts#save_address", as: :save_address_checkout

  get "/pages/:slug", to: "pages#show", as: :page
  get "/about", to: "pages#show", defaults: { slug: "about" }, as: :about
  get "/contact", to: "pages#show", defaults: { slug: "contact" }, as: :contact

  resource :checkout, controller: "checkouts", only: [] do
    get :address
    post :address, action: :save_address

    get :review
    get :confirm
    post :complete
  end
end
