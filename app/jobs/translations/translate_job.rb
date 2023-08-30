# frozen_string_literal: true

class Translations::TranslateJob < ApplicationJob
  queue_as :default

  def perform(id)
    return unless Rails.env.production?

    Translation.find_by(id:)&.translate!
  rescue Llm::APIError => e
    logger.error(e)
    self.class.set(wait: SecureRandom.random_number(120).seconds).perform_later(id)
  end
end
