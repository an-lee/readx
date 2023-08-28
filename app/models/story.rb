# frozen_string_literal: true

# == Schema Information
#
# Table name: stories
#
#  id           :uuid             not null, primary key
#  domain       :string
#  embedding    :vector
#  html         :text
#  locale       :string           default("en"), not null
#  published_at :datetime
#  score        :integer          default(0), not null
#  sentiment    :string           default("neutral")
#  source       :jsonb            not null
#  status       :string           default("drafted"), not null
#  story_type   :string           default("fact"), not null
#  summary      :text
#  title        :string
#  url          :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  topic_id     :uuid
#
# Indexes
#
#  index_stories_on_sentiment   (sentiment)
#  index_stories_on_story_type  (story_type)
#  index_stories_on_topic_id    (topic_id)
#  index_stories_on_url         (url) UNIQUE
#
class Story < ApplicationRecord
  include Stories::Analyzable
  include Stories::Collectable
  include Stories::Classifiable
  include Stories::Scrapable
  include Stories::Translatable

  include AASM
  extend Enumerize

  enumerize :sentiment, in: %i[positive neutral negative], predicates: true, scope: true
  enumerize :story_type, in: %i[fact opinion], predicates: true, scope: true

  belongs_to :topic, optional: true, counter_cache: true

  has_many :llm_messages, as: :source, dependent: :destroy
  has_many :analyze_messages, -> { where(llm_message_type: 'analyze').order(updated_at: :desc) }, class_name: 'LlmMessage', as: :source, inverse_of: false, dependent: nil
  has_many :embed_messages, -> { where(llm_message_type: 'embed').order(updated_at: :desc) }, class_name: 'LlmMessage', as: :source, inverse_of: false, dependent: nil

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :translations, as: :translatable, dependent: :destroy

  has_neighbors :embedding

  before_validation :setup_default_attributes

  # after_commit :scrape_metadata_async, on: :create

  delegate :present?, to: :html, prefix: true
  delegate :present?, to: :summary, prefix: true
  delegate :positive?, to: :score, prefix: true

  aasm column: :status do
    state :drafted, initial: true
    state :scraped
    state :analyzed
    state :classified
    state :dropped

    event :scrape, guards: :html_present?, after_commit: :analyze_content_async do
      transitions from: :drafted, to: :scraped
    end

    event :analyze, guards: :summary_present?, after_commit: :classify_topic_async do
      transitions from: :scraped, to: :analyzed
    end

    event :classify, guards: :score_positive?, after_commit: :translate! do
      transitions from: :analyzed, to: :classified
    end

    event :drop do
      transitions from: %i[scraped analyzed classified], to: :dropped
    end
  end

  def related_stories
    @related_stories ||= Story.where(id: neighbor_ids)
  end

  def neighbor_ids
    return @neighbor_ids if @neighbor_ids.present?
    return if embedding.blank?
    return Rails.cache.read(neighbor_ids_cache_key) if Rails.cache.exist?(neighbor_ids_cache_key)

    ids = []
    nearest_neighbors(:embedding, distance: :cosine).first(50).each do |neighbor|
      break if neighbor.neighbor_distance > 0.1

      ids << neighbor.id
    end

    Rails.cache.write(neighbor_ids_cache_key, ids, expires_in: 3.minutes)
    @neighbor_ids = ids
  end

  def neighbor_ids_cache_key
    "story:#{id}:neighbors"
  end

  def domain_name
    return if domain.blank?

    domain.split('.').last(2).join('.')
  end

  def video?
    youtube? || bilibili?
  end

  def video_embed_url
    return youtube_embed_url if youtube?

    bilibili_embed_url if bilibili?
  end

  def youtube?
    yt_id.present?
  end

  def youtube_embed_url
    "https://www.youtube.com/embed/#{yt_id}"
  end

  def yt_id
    if url.match?(%r{\Ahttps?://(www\.)?(youtu\.be|youtube\.com/shorts)/})
      url.split('/').compact.last
    elsif url.match?(%r{\Ahttps?://(www\.)?youtube\.com/watch})
      URI.parse(url).query&.split('&')&.find { |q| q.start_with? 'v=' }&.split('=')&.last
    end
  end

  def bilibili?
    url.match?(%r{\Ahttps?://(www\.)?bilibili\.com})
  end

  def bilibili_id
    return unless bilibili?

    URI.parse(url).path.split('/').compact.last
  end

  def bilibili_embed_url
    "https://player.bilibili.com/player.html?bvid=#{bilibili_id}&autoplay=0"
  end

  private

  def setup_default_attributes
    self.domain = URI.parse(url).host
  end
end
