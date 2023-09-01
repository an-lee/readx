# frozen_string_literal: true

class Stories::CollectBlogsFromGoogleJob < ApplicationJob
  queue_as :default

  def perform
    return unless Rails.env.production?

    Story.collect_from_google(type: 'blog', time_period: 'last_day', page: 1, num: 10)
  end
end
