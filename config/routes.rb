Rails.application.routes.draw do
  root "gadgets#top"

  resources :gadgets do
    collection do
      get 'top'
    end
    resource :likes, only: [:create, :destroy]
    get 'liked_users', on: :member
  end

  devise_for :users,
    controllers: {
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  get '/users', to: 'users#index', as: 'users'
  get '/users/mygadgets/:id', to: 'users#show_mygadgets', as: 'user_mygadgets'
  get '/users/favorites/:id', to: 'users#show_favorites', as: 'user_favorites'
  get 'users/profile/:id/edit', to: 'users#edit_profile', as: 'edit_user_profile'
  get 'users/account/:id', to: 'users#account', as: 'user_account'
end
