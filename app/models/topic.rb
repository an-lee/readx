# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id            :uuid             not null, primary key
#  embedding     :vector
#  slug          :string
#  stories_count :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  source_id     :uuid             not null
#
# Indexes
#
#  index_topics_on_slug       (slug) UNIQUE
#  index_topics_on_source_id  (source_id)
#
class Topic < ApplicationRecord
  include AASM
  extend FriendlyId

  friendly_id :title, use: :slugged

  belongs_to :source, class_name: 'Story'

  has_many :stories, dependent: nil
  has_many :translations, as: :translatable, dependent: :destroy
  has_many :tags, through: :stories

  has_neighbors :embedding

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :summary, presence: true

  default_scope { includes(:source).order('stories.published_at DESC') }
  delegate :title, :summary, :content, :url, :published_at, to: :source

  scope :hot, -> { where(stories_count: 2...) }

  def related_topics
    @related_topics ||= Topic.where(id: neighbor_ids)
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
    "topic:#{id}:neighbors"
  end
end
