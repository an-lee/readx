# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount Sidekiq::Web, at: 'sidekiq'

  resources :topics, only: %i[index show]
  resources :stories, only: %i[index show]

  # Defines the root path route ("/")
  root 'topics#index'
end
