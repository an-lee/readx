# frozen_string_literal: true

Rails.application.routes.draw do
  draw :madmin

  get 'service-worker.js', to: 'service_worker#service_worker'
  get 'manifest.json', to: 'service_worker#manifest'

  get 'daily', to: 'daily#index'

  resources :topics, only: %i[index show]
  resources :stories, only: %i[index show]

  # Defines the root path route ("/")
  root 'topics#index'
end
