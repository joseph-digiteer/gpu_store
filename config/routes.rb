Rails.application.routes.draw do
  devise_for :users

  # Admin namespace
  namespace :admin do
    resources :products
    resources :product_variants, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :customers, only: [:index, :show, :edit, :update, :destroy]
    resources :orders, only: [:index, :show, :edit, :update, :destroy]
    resources :order_items, only: [:index, :show, :edit, :update, :destroy]
    resources :cart_items, only: [:index, :show, :edit, :update, :destroy]
    resources :vouchers, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  # Customer namespace
  namespace :customers do
    resources :products, only: [:index, :show]
    resources :cart_items, only: [:index, :create, :update, :destroy]
    resources :orders, only: [:index, :show, :create]
    resources :order_items, only: [:index, :show, :create, :update, :destroy]
  end
  
  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
