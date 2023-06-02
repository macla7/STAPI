Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root 'pages#home'

  draw :api

  get 'users/:id/confirmed', to: 'users#confirmed', as: 'confirmed'
  get 'already_confirmed', to: 'users#already_confirmed'
end
