Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations] 

  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'    
    patch 'users' => 'devise/registrations#update', :as => 'user_registration'            
  end

  root to: "home#index"

  get '/dashboard', to: 'dashboard#index'
  get '/filter', to: 'dashboard#index'

  resources :donations
end
