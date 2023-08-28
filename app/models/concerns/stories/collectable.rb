# frozen_string_literal: true

module Stories::Collectable
  extend ActiveSupport::Concern

  class_methods do
    def collect_from_google(type: 'news', time_period: nil, page: 1)
      news_type =
        case type
        when 'news'
          'all'
        when 'blogs'
          'blogs'
        end

      r = Valueserp.api.search('crypto', time_period:, news_type:, page:)

      r['news_results'].each do |result|
        result.delete('thumbnail')

        create_with(
          title: result['title'],
          published_at: result['date_utc'],
          source: result
        ).find_or_create_by(
          url: result['link']
        )
      end
    end

    def collect_from_crypto_panic
    end
  end
end
