# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'sidekiq_unique_jobs/web'

class AdminConstraint
  def matches?(request)
    return false if request.session[:current_admin_id].blank?

    Administrator.find_by(id: request.session[:current_admin_id]).present?
  end
end

namespace :admin do
  # sidekiq
  mount Sidekiq::Web, at: 'sidekiq', constraints: AdminConstraint.new
end
