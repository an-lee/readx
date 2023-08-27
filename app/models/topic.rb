# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id         :uuid             not null, primary key
#  content    :text
#  embedding  :vector
#  locale     :string           default("en"), not null
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
  extend FriendlyId

  friendly_id :title, use: :slugged

  has_many :stories, dependent: nil
  has_many :translations, as: :translatable, dependent: :destroy

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

  def translate!(lang = 'zh-CN')
    return if locale == lang

    %i[title content summary].each do |attr|
      next if attr.blank?

      translations.find_or_create_by!(
        key: attr,
        locale: lang
      )
    end
  end

  def summary_in(locale = 'zh-CN')
    translations.find_or_create_by(key: :summary, locale:)&.value || summary
  end

  def content_in(locale = 'zh-CN')
    return if content.blank?

    translations.find_or_create_by(key: :content, locale:)&.value || content
  end

  def title_in(locale = 'zh-CN')
    translations.find_or_create_by(key: :title, locale:)&.value || title
  end
end
