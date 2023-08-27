# frozen_string_literal: true

module CryptoPanic
  def self.api
    @api ||= CryptoPanic::API.new(Rails.application.credentials.dig(:crypto_panic, :auth_token))
  end
end
