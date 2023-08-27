# frozen_string_literal: true

module CryptoPanic
  class API
    attr_reader :conn

    def initialize(auth_token)
      @conn = Faraday.new(url: 'https://cryptopanic.com') do |f|
        f.request :json
        f.request :retry
        f.response :json
        f.response :logger
      end

      @auth_token = auth_token
    end

    # available params:
    # - public: true/false
    # - filter: rising|hot|bullish|bearish|important|saved|lol
    # - currencies: BTC,ETH,...
    # - regions: EN,CN,...
    # - kinds: all|news|media
    def posts(**params)
      conn.get('api/v1/posts/', params.merge(auth_token: @auth_token)).body
    end
  end
end
