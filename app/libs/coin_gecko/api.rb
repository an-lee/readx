# frozen_string_literal: true

module CoinGecko
  class API
    attr_reader :conn

    def initialize
      @conn = Faraday.new(url: 'https://api.coingecko.com') do |f|
        f.request :json
        f.request :retry
        f.response :json
        f.response :logger
      end
    end

    def coins_markets(vs_currency = 'usd')
      path = 'api/v3/coins/markets'
      params = {
        vs_currency:
      }
      conn.get(path, params).body
    end
  end
end
