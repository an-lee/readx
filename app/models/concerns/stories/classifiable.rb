# frozen_string_literal: true

module Stories::Classifiable
  extend ActiveSupport::Concern

  def classify_topic!
    return if topic.present?
    return if content.blank?

    embed_message.embed if embed_message.pending?
    update(embedding: embed_message.result) if embedding.blank?

    update(topic: find_or_create_topic) if topic.blank?

    classify! if may_classify?
  end

  def classify_topic_async
    Stories::ClassifyJob.perform_later id
  end

  def find_or_create_topic
    return nearest_topic if nearest_topic.present? && nearest_topic.neighbor_distance < 0.1
    return unless fact?

    Topic.create!(
      embedding:,
      source: self
    )
  end

  def nearest_topic
    return if embedding.blank?

    @nearest_topic ||= Topic.nearest_neighbors(:embedding, embedding, distance: :cosine).first
  end

  def embed_message
    @embed_message ||= embed_messages.first || embed_messages.create!(
      prompt: summary
    )
  end
end
