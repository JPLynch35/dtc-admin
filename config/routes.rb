Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations] 

  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'    
    patch 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  devise_scope :user do
    authenticated :user do
      root 'dashboard#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  get '/dashboard', to: 'dashboard#index'
  get '/filter', to: 'dashboard#index'

  resources :donations, only: [:create, :destroy]
  resources :contacts, only: [:create, :destroy]
  resources :users, only: [:create, :destroy]
end
