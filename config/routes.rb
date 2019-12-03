Rails.application.routes.draw do
  root 'plants#index'

  resource :session, only: [:new, :create, :destroy]
  resources :users
  resources :plants
end