# frozen_string_literal: true

# Below are the routes for madmin

require 'sidekiq/web'
require 'sidekiq/cron/web'

class AdminConstraint
  def matches?(request)
    return false if request.session[:current_admin_id].blank?

    Administrator.find_by(id: request.session[:current_admin_id]).present?
  end
end

get 'madmin/login', to: 'madmin/sessions#new'
post 'madmin/login', to: 'madmin/sessions#create'

namespace :madmin, constraints: AdminConstraint.new do
  # sidekiq
  mount Sidekiq::Web, at: 'sidekiq'

  resources :administrators
  resources :llm_messages
  resources :stories
  resources :topics
  resources :tags
  resources :taggings
  resources :translations

  root to: 'dashboard#show'
end
