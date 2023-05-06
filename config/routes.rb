Rails.application.routes.draw do
  root "gadgets#top"

  resources :gadgets do
    collection do
      get 'top'
    end
    resource :likes, only: [:create, :destroy]
    get 'liked_users', on: :member
    resources :comments, only: [:create, :destroy, :index]
  end

  devise_for :users,
    controllers: {
      registrations: 'users/registrations',
      passwords: 'users/passwords', 
      sessions: 'users/sessions'
    }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resources :users, only: [:index] do
    member do
      get 'mygadgets', to: 'users#show_mygadgets', as: 'mygadgets'
      get 'favorites', to: 'users#show_favorites', as: 'favorites'
      get 'profile/edit', to: 'users#edit_profile', as: 'edit_profile'
      get 'account', to: 'users#account', as: 'account'
    end
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  get 'terms_of_service', to: 'static_pages#terms_of_service'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
end
