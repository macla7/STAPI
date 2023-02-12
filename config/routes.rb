Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  resources :memberships
  resources :groups
  resources :posts, :books

  devise_for :users, controllers: { passwords: 'users/passwords' }
  root 'pages#home'

  draw :api
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
