# frozen_string_literal: true

Rails.application.routes.draw do
  # ルート`/`をウェルカムページに設定
  root 'welcome#index'

  # Devise Token Auth routes
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }

  # Messages routes
  resources :messages, only: %i[index create update destroy] do
    member do
      resources :likes, only: [:create]
    end
  end

  # Likes routes
  resources :likes, only: [:destroy]

  # ActionCable
  mount ActionCable.server => '/cable'

  # 他のAPIエンドポイントのルート設定
  get '/your_api_endpoint', to: 'api#your_action'
end
