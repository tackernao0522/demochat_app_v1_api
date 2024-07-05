# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations',
    sessions: 'auth/sessions'
  }

  resources :messages, only: ['index'] do
    member do
      resources :likes, only: ['create']
    end
  end

  resources :likes, only: ['destroy']

  get '/your_api_endpoint', to: 'api#your_action'
end
