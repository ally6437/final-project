Rails.application.routes.draw do
  #get 'pages/show'
  get '/pages/:title', to: 'pages#show', as: 'pages_show'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :payments
  resources :orders
  resources :cart_items
  resources :carts
  resources :order_items
  resources :products, only: [:index, :show]
  resources :categories
  resources :users
  root to: "products#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  #resources :products, only: [:index, :show] do
  #  collection do
  #    get :search
  #  end
 # end
 Rails.application.routes.draw do


  get 'products/search', to: 'products#search', as: 'search_products'

  resources :products
end

end
