Rails.application.routes.draw do
  get 'cart/cart'
  devise_for :restaurants, controllers: {
    registrations: 'restaurants/registrations',
    sessions: 'restaurants/sessions'
  }

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  root to: "pages#home"
  # root to: "pages#authentication"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "pages/auth", to: "pages#authentication", as: :auth
  # routes for pages
  resources :pages
  # Defined routes for the restaurants
  get 'restaurants/dashboard', to: 'restaurants/dashboard#dashboard'
  get 'restaurants/:id/notification', to: 'restaurants/dashboard#notification', as: :restaurant_notification
  get 'users/dashboard', to: 'users/dashboard#dashboard'
  get 'users/:id/notification', to: 'users/dashboard#notification', as: :user_notification

  resources :restaurants do
    resources :reviews
    # Nested routes - foods belonging to restaurant
    resources :foods, only: [:new, :create, :edit, :index, :show]
    resources :foods, only: [:new, :create, :index, :show] do
      member do
        patch :published, :unpublished
      end
    end

    # Nested routes - reviews belonging to restaurant
    resources :reviews, only: [:index, :create, :new]
    # Nested routes - orders related to a specific restaurant
    # resources :orders, only: [:index, :create, :new]
  end

  resources :foods do
    resources :order_lines, only: [:create]
    patch :published, on: :collection
  end

  resources :orders do
    member do
      patch 'checkout'
    end
    collection do
      get 'past'
    end
  end



  resources :foods, only: [:edit, :update, :destroy, :show]

  get '/search', to: 'search#list', as: :search
  get '/search/map', to: 'search#map', as: :search_map

  # routes related to orders and carts
  get '/cart', to: 'cart#cart', as: :cart
  get 'order_lines/:id' => "order_lines#show", as: "order_lines"

  get 'order_lines/:id/add' => "order_lines#add_quantity", as: "orders_lines_quantity"
  post 'order_lines/:id/add' => "order_lines#add_quantity", as: "order_lines_add"
  get 'order_lines/:id/reduce' => "order_lines#reduce_quantity", as: "orders_reduce"
  post 'order_lines/:id/reduce' => "order_lines#reduce_quantity", as: "order_lines_reduce"
  delete 'order_lines/:id' => "order_lines#destroy"

  # resources :order_lines do
  #   collection do
  #     get 'previous_order'
  #   end
  # end
  # Defines the root path route ("/")
  # root "posts#index"
end
