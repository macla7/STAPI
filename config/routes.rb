Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root 'privacy_policy#home', to: 'privacy_policy#home'
  get 'support/how_to', to: 'support#how_to'
  get 'support/contact_us', to: 'support#contact_us'

  draw :api

  get 'users/:id/confirmed', to: 'users#confirmed', as: 'confirmed'
  get 'users/:id/already_confirmed', to: 'users#already_confirmed', as: 'already_confirmed'
end
