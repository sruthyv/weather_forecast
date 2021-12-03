Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'users#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :weather, only: [] do
    collection do
      post :forecast
    end
  end

  resources :users do
    post :change_temperature
  end
end
