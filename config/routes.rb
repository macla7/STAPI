Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root 'pages#home'

  draw :api

  get 'users/:id/confirmed', to: 'users#confirmed', as: 'confirmed'
  get 'users/:id/already_confirmed', to: 'users#already_confirmed', as: 'already_confirmed'
end
