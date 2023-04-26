Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  devise_scope :user do
    match '/users/sign_out' => 'sessions#destroy', via: [:get, :delete]
    get '/users/edit_address', to: 'users#edit_address', as: 'edit_address'
    patch '/users/update_address', to: 'users#update_address', as: 'update_address'
  end

  resources :provinces
  #get 'pages/show'
  get '/pages/:title', to: 'pages#show', as: 'pages_show'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get '/products/search', to: 'products#search', as: 'product_search'
  resources :payments
  resources :orders
  resources :cart_items
  resources :carts, only: [:index] do
    collection do
      post 'add_to_cart', to: 'carts#add_to_cart', as: 'add_to_cart'
      get 'remove_from_cart', to: 'carts#remove_from_cart', as: 'remove_from_cart'
      post 'update_quantity', to: 'carts#update_quantity', as: 'update_quantity'
    end
  end
  resources :order_items
  resources :products, only: [:index, :show]
  resources :categories
  #resources :users
  resources :products do
    collection do
      get 'search'
    end
  end
  root to: "products#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
