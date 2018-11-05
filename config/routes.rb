Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  get '/dashboard', to: 'dashboard#index'
  get '/filter', to: 'dashboard#index'

  resources :donations, only: [:create, :destroy]
  resources :contacts, only: [:create, :destroy]
end
