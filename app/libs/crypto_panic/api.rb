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
    # - kind: all|news|media
    def posts(**params)
      default_params = {
        auth_token: @auth_token,
        public: true,
        meatdata: true,
        kind: 'news'
      }
      conn.get('api/v1/posts/', default_params.merge(params.compact_blank)).body
    end
  end
end
