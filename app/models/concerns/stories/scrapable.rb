# frozen_string_literal: true

module Stories::Scrapable
  extend ActiveSupport::Concern

  def metadata
    scrape_metadata if html.blank?

    @metadata ||= MetaInspector.new(url, document: html, encoding: 'utf-8')
  end

  def scrape_metadata!
    return unless URI.parse(url).scheme.in?(%w[http https])
    return if video?
    return if html.present?

    page =
      begin
        MetaInspector.new(url, encoding: 'utf-8', connection_timeout: 10, read_timeout: 10, retries: 3)
      rescue MetaInspector::TimeoutError
        doc = Scraper.api.scrape(url)
        MetaInspector.new(url, document: doc, encoding: 'utf-8')
      end

    update(
      url: page.url,
      title: page.title,
      html: page.to_s
    )

    if may_scrape?
      scrape!
    elsif drafted? && content.blank?
      drop!
    end
  rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation::ERROR
    destroy
  end

  def scrape_metadata_async
    Stories::ScrapeJob.perform_later id
  end

  def content
    @content ||=
      begin
        ReverseMarkdown.convert(Readability::Document.new(html).content)
      rescue StandardError
        ''
      end
  end
end
