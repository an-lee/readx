# frozen_string_literal: true

module Stories::Classifiable
  extend ActiveSupport::Concern

  def classify_topic!
    return if drafted? || dropped?
    return if topic.present?
    return if content.blank?

    embed_message.embed if embed_message.pending?
    update(embedding: embed_message.result) if embedding.blank?

    update(topic: find_or_generate_topic) if topic.blank?

    classify! if may_classify?
  end

  def classify_topic_async
    Stories::ClassifyJob.perform_later id
  end

  def find_or_generate_topic
    return nearest_topic if nearest_topic.present? && nearest_topic.neighbor_distance < 0.15

    Topic.create!(
      embedding:,
      published_at:,
      source: self
    )
  end

  def nearest_topic
    return if embedding.blank?

    @nearest_topic ||=
      Topic
      .where(
        published_at: (published_at - 24.hours)...(published_at + 24.hours)
      ).nearest_neighbors(:embedding, embedding, distance: :cosine).first
  end

  def embed_message
    @embed_message ||= embed_messages.first || embed_messages.create!(
      prompt: summary
    )
  end
end
