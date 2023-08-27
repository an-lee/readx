# frozen_string_literal: true

module Scraper
  def self.api
    @api ||= Scraper::API.new(Rails.application.credentials.dig(:scraper, :api_key))
  end
end
