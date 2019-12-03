Rails.application.routes.draw do
  root 'users#index'

  resource :session, only: [:new, :create, :destroy]
  resources :users
  resources :plants
end
