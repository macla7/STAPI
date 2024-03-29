namespace :api do
  namespace :v1 do

    devise_for :users, controllers: {
        passwords: 'api/v1/users/passwords'
      }, skip: :registration
    
    scope :users, module: :users do
      post '/', to: 'registrations#create', as: :user_registration
      post '/session-data/with-token', to: 'sessions#show'
      post '/session-data', to: 'sessions#create'
    end

    resources :users do
      resources :push_tokens
      resources :shifts 
      member do
        get 'for_month', to: 'shifts#for_month'
      end
      member do
        get '/token/:token/confirm_email', to: 'users#confirm_email', as: 'confirm_email'
      end
      member do
        get '/coworkers', to: 'users#coworkers', as: 'coworkers'
      end
      member do
        get '/coworkers2', to: 'users#coworkers2', as: 'coworkers2'
      end
    end

    resources :likes
    resources :bids, only: [:create]
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
    get '/invites/pending', to: 'invites#index_pending'
    put '/bids/bulk_update', to: 'bids#bulk_update'
    
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