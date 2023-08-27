# frozen_string_literal: true

class Stories::ScrapeJob < ApplicationJob
  queue_as :high

  def perform(id)
    Story.find_by(id:)&.scrape_metadata!
  end
end
