# frozen_string_literal: true

class Stories::ScrapeJob < ApplicationJob
  queue_as :high

  def perform(id)
    return unless Rails.env.production?

    Story.find_by(id:)&.scrape_metadata!
  end
end
