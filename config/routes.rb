Rails.application.routes.draw do
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

  root "gadgets#top"
end
