# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id         :uuid             not null, primary key
#  content    :text
#  embedding  :vector
#  slug       :string
#  summary    :text
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_topics_on_slug  (slug) UNIQUE
#
class Topic < ApplicationRecord
  has_many :stories, dependent: nil

  has_neighbors :embedding

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :summary, presence: true

  def related_topics
    @related_topics ||= Topic.where(id: neighbor_ids)
  end

  def neighbor_ids
    return if ebmedding.blank?
    return Rails.cache.read(neighbor_ids_cache_key) if Rails.cache.exist?(neighbor_ids_cache_key)

    ids = []
    nearest_neighbors(:embedding, distance: :cosine).first(50).each do |neighbor|
      break if neighbor.neighbor_distance > 0.1

      ids << neighbor.id
    end

    Rails.cache.write(neighbor_ids_cache_key, ids)
    ids
  end

  def neighbor_ids_cache_key
    "topic:#{id}:neighbors"
  end
end
