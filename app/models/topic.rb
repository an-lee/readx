# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id            :uuid             not null, primary key
#  embedding     :vector
#  published_at  :datetime
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

  delegate :title, :summary, :content, \
           :title_text, :summary_text, :content_text, \
           :url, \
           to: :source

  scope :hot, -> { where(stories_count: 2...).includes(:source).order(published_at: :desc) }

  def related_topics
    @related_topics ||= Topic.where(id: neighbor_ids)
  end

  def neighbor_ids
    return @neighbor_ids if @neighbor_ids.present?
    return if embedding.blank?
    return Rails.cache.read(neighbor_ids_cache_key) if Rails.cache.exist?(neighbor_ids_cache_key)

    ids = []
    neighbors.each do |neighbor|
      ids << neighbor.id if neighbor.neighbor_distance < 0.1
    end

    Rails.cache.write(neighbor_ids_cache_key, ids, expires_in: 3.minutes)
    @neighbor_ids = ids
  end

  def neighbors(num = 50)
    @neighbors ||= nearest_neighbors(:embedding, distance: :cosine).first(num)
  end

  def neighbor_ids_cache_key
    "topic:#{id}:neighbors"
  end

  def to_meta_tags
    {
      title: title_text,
      description: summary_text,
      keywords: tags.pluck(:name).join(',')
    }
  end
end
