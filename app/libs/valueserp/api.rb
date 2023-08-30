# frozen_string_literal: true

module Valueserp
  class API
    attr_reader :conn

    def initialize(api_key)
      @conn = Faraday.new(url: 'https://api.valueserp.com') do |f|
        f.request :json
        f.request :retry
        f.response :json
        f.response :logger
      end

      @api_key = api_key
    end

    # available params:
    # - search_type: news|images|videos|places|place_details|shopping|product
    # - news_type: all|blogs
    # - show_duplicates: true|false
    # - google_domain: google.com
    # - gl: us
    # - sort_by: date|relevance
    # - time_period: last_day
    # - num: 100
    # - page: 1
    def search(query, **params)
      default_params = {
        api_key: @api_key,
        q: query,
        search_type: 'news',
        news_type: 'all',
        # show_duplicates: false,
        google_domain: 'google.com',
        gl: 'us',
        # sort_by: 'relevance',
        num: 100,
        page: 1
      }

      conn.get('search', default_params.merge(params).compact).body
    end
  end
end
