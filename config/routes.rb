# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  
  root to: 'tweets#index'

  # ユーザーリソース
  resource :user_profile, only: %i[edit update], controller: 'users'
  resources :users, only: %i[show] do
    member do
      get :retweets, :comments, :likes
    end
  end

  # tweets リソース
  resources :tweets, only: [:index] do
    collection do
      get :following
    end
  end
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
