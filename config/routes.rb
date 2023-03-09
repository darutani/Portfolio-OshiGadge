Rails.application.routes.draw do
  root "gadgets#top"

  resources :gadgets do
    collection do
      get 'top'
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  get '/users', to: 'users#index', as: 'users'
  get '/users/mygadgets/:id', to: 'users#show_mygadgets', as: 'user_mygadgets'
  get '/users/favorites/:id', to: 'users#show_favorites', as: 'user_favorites'

  resources :profiles, only: [:edit]
end
