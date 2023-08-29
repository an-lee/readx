# frozen_string_literal: true

class Stories::CollectFromGoogleJob < ApplicationJob
  queue_as :default

  def perform
    return unless Rails.env.production?

    Story.collect_from_google
  end
end
