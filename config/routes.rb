Rails.application.routes.draw do
  root 'welcomes#index'

  resources :welcomes, only: :index

  resources :users, only: %i(create destroy)
  resources :invites, only: %i(create update)
  resources :games, only: %i(show update)
end
