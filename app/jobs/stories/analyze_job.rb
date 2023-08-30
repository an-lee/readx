# frozen_string_literal: true

class Stories::AnalyzeJob < ApplicationJob
  queue_as :high

  def perform(id)
    return unless Rails.env.production?

    Story.find_by(id:)&.analyze_content!
  rescue Llm::APIError => e
    logger.error(e)
    self.class.set(wait: SecureRandom.random_number(120).seconds).perform_later(id)
  end
end
