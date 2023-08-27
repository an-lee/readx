# frozen_string_literal: true

class Stories::ClassifyJob < ApplicationJob
  queue_as :high

  def perform(id)
    Story.find_by(id:)&.classify_topic!
  rescue Llm::APIError => e
    logger.error(e)
    self.class.set(wait: SecureRandom.random_number(120).seconds).perform_later(id)
  end
end
