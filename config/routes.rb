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

      post "order/product", :to => "order_products#create"
      get "order/product/:id", :to => "order_products#show"
      get "order/product", :to => "order_products#index"
      put "order/product/:id", :to => "order_products#update"
    end
  end
end
