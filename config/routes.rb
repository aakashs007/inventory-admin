Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "admin/dashboard#index"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :api, default: { format: :json} do
    namespace :v1 do
      get "order", :to => "orders#index"
      get "order/:id", :to => "orders#show"
      post "order", :to => "orders#create"
      put "order/:id", :to => "orders#update"

      post "order_product", :to => "order_products#create"
      get "order_product/:id", :to => "order_products#show"
      get "order_product", :to => "order_products#index"
      put "order_product/:id", :to => "order_products#update"
      delete "order_product/:id", :to => "order_products#destroy"

      get "product", :to => "products#index"

      get "user", :to => "users#index"

      get "warehouse", :to => "warehouse#index"

      get "stock", :to => "stocks#index"
    end
  end
end
