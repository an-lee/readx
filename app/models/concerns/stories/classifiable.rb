# frozen_string_literal: true

module Stories::Classifiable
  extend ActiveSupport::Concern

  def classify_topic!
    return if topic.present?
    return if content.blank?

    embed_message.embed if embed_message.pending?
    update(embedding: embed_message.result) if embedding.blank?

    if find_topic.present? && find_topic.neighbor_distance < 0.1
      update(topic: find_topic)
    else
      Topic.create!(
        title:,
        summary:,
        embedding:
      )
    end

    classify! if may_classify?
  end

  def classify_topic_async
    Stories::ClassifyJob.perform_later id
  end

  def find_topic
    return if embedding.blank?

    @find_topic ||= Topic.nearest_neighbors(:embedding, embedding, distance: :cosine).first
  end

  def embed_message
    @embed_message ||= embed_messages.first || embed_messages.create!(
      prompt: summary
    )
  end
end
