# frozen_string_literal: true

Rails.application.routes.draw do
  # devise_for :users, controllers: { sessions: 'users/sessions' }
  root to: 'home#index'
  devise_for :users, controllers: { registrations: 'users/registrations', confirmations: 'users/confirmations' }
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
