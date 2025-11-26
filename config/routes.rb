Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :products
  root "products#index"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :cart, only: [:index] do
    collection do
      post "add/:product_id", to: "cart#add", as: "add"
      post "remove/:product_id", to: "cart#remove", as: "remove"
      post "clear", to: "cart#clear"
    end
  end

end
