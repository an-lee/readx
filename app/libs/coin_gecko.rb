# frozen_string_literal: true

module CoinGecko
  def self.api
    @api ||= CoinGecko::API.new
  end

  def self.coins_markets_cache
    Rails.cache.fetch('coin_gecko_coins_markets', expires_in: 30.seconds) do
      CoinGecko.api.coins_markets || []
    end
  rescue StandardError
    []
  end
end
