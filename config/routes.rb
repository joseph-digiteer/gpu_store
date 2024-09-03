Rails.application.routes.draw do
  devise_for :users

  # Admin namespace
  namespace :admin do
  #Products -> Product variants i don't understand my 
    resources :products do
      resources :variants, only: [:edit, :update, :destroy]
      resources :product_variants, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    end
    resources :customers, only: [:index, :show, :edit, :update, :destroy]
    resources :orders, only: [:index, :show, :edit, :update, :destroy]
    resources :order_items, only: [:index, :show, :edit, :update, :destroy]
    resources :cart_items, only: [:index, :show, :edit, :update, :destroy]
    resources :vouchers, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  # Customer namespace
  namespace :customers do
    resources :products, only: [:index, :show]
    resources :cart_items, only: [:create, :update, :destroy]
    #create check POST, for check out button
    resource :cart, only: [:show, :update, :destroy] do
      post 'checkout', on: :member
    end
    resources :orders, only: [:index, :show, :create]
    resources :order_items, only: [:index, :show, :create, :update, :destroy]
    
    # Custom route for adding items to the cart
    get 'cart', to: 'carts#show'
    post 'add_to_cart', to: 'cart_items#create', as: 'add_to_cart'
  end
  
  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
