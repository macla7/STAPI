namespace :api do
  namespace :v1 do
    scope :users, module: :users do
      post '/', to: 'registrations#create', as: :user_registration
      get '/session-data', to: 'sessions#show'
      post '/session-data', to: 'sessions#create'
    end

    resources :users
    resources :likes
    resources :bids
    resources :notification_blueprints
    resources :notifications
    resources :comments
    
    resources :posts do
      resources :likes, only: [:index]
      resources :bids, only: [:index]
      resources :comments, only: [:index]
    end

    resources :groups do
      resources :memberships, :invites
      resources :posts, only: [:index]
      get '/requests', to: 'invites#index_requests'
      put '/requests/:id', to: 'invites#update_request'
      get '/users', to: 'users#index'
    end

    get '/likes/destroy', to: 'likes#destroy'
    get '/home', to: 'posts#index_home'
    get '/myGroups', to: 'groups#my_groups'
    get '/otherGroups', to: 'groups#other_groups'
    
    namespace :android do
      resources :books
    end

  end
end

scope :api do
  scope :v1 do
    use_doorkeeper do
      skip_controllers :authorization, :applications, :authorized_applications
    end
  end
end