# frozen_string_literal: true

module Scraper
  class API
    attr_reader :conn

    def initialize(api_key)
      @conn = Faraday.new do |f|
        f.request :json
        f.request :retry
        f.response :json
        f.response :logger
      end

      @api_key = api_key
    end

    def batch_scrape(urls, **kwargs)
      conn.post do |req|
        req.url 'https://async.scraperapi.com/batchjobs'
        req.body = {
          urls:,
          apiKey: @api_key,
          apiParams: kwargs.compact
        }.compact
      end.body
    end

    def scrape_async(url, **kwargs)
      conn.post do |req|
        req.url 'https://async.scraperapi.com/jobs'
        req.body = {
          url:,
          apiKey: @api_key,
          apiParams: kwargs.compact
        }.compact
      end.body
    end

    def status(url)
      conn.get do |req|
        req.url url
      end.body
    end

    def scrape(url)
      conn.get("http://api.scraperapi.com?api_key=#{@api_key}&url=#{url}").body
    end

    def search_google(query)
      conn.get do |req|
        req.url 'https://api.scraperapi.com/structured/google/search'
        req.params = {
          api_key: @api_key,
          query:,
          tld: 'com',
          NUM: 100,
          time_period: '1D'
        }
      end.body
    end
  end
end
