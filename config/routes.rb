# frozen_string_literal: true

Rails.application.routes.draw do
  # ルート`/`をウェルカムページに設定
  root 'welcome#index'

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }

  resources :messages, only: ['index'] do
    member do
      resources :likes, only: ['create']
    end
  end

  resources :likes, only: ['destroy']

  # 他のAPIエンドポイントのルート設定
  get '/your_api_endpoint', to: 'api#your_action'
end
