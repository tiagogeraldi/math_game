Rails.application.routes.draw do
  root 'welcomes#index'

  resources :welcomes, only: :index

  resources :users, only: %i(new create destroy)
  resources :invites, only: %i(create update destroy)
  resources :games, only: %i(show update) do
    resources :rounds, only: %i(update)
  end
end
