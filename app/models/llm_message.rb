# frozen_string_literal: true

# == Schema Information
#
# Table name: llm_messages
#
#  id               :uuid             not null, primary key
#  context          :text
#  llm_message_type :string
#  prompt           :text             not null
#  response         :jsonb
#  source_type      :string
#  status           :string           default("pending"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  source_id        :uuid
#
# Indexes
#
#  index_llm_messages_on_llm_message_type  (llm_message_type)
#  index_llm_messages_on_source            (source_id,source_type)
#
class LlmMessage < ApplicationRecord
  DEFAULT_CHAT_PARAMETERS = {
    model: 'gpt-3.5-turbo',
    temperature: 0.0
  }.freeze
  DEFAULT_EMBED_PARAMETERS = {
    model: 'text-embedding-ada-002'
  }.freeze

  include AASM
  extend Enumerize

  belongs_to :source, polymorphic: true, optional: true

  validates :prompt, presence: true

  delegate :present?, to: :response, prefix: true

  aasm column: :status do
    state :pending, initial: true
    state :completed

    event :complete, guards: :response_present? do
      transitions from: :pending, to: :completed
    end
  end

  enumerize :llm_message_type, in: %i[analyze translate embed]

  def result
    @result ||=
      case llm_message_type
      when 'analyze', 'translate'
        response.dig('choices', 0, 'message', 'content')
      when 'embed'
        response.dig('data', 0, 'embedding')
      end
  end

  def process!
    case llm_message_type
    when 'analyze', 'translate'
      chat
    when 'embed'
      embed
    end
  end

  def chat(**options)
    return result if response_present?

    parameters = DEFAULT_CHAT_PARAMETERS.merge(options).merge(
      messages: compose_chat_messages
    )

    r = Llm.openai.chat(
      parameters:
    )

    update response: r
    complete! if may_complete?
  end

  def embed
    return result if response_present?

    parameters = DEFAULT_EMBED_PARAMETERS.merge(
      input: prompt
    )

    r = Llm.openai.embeddings(
      parameters:
    )

    update response: r
    complete! if may_complete?
  end

  def compose_chat_messages
    history = []

    history.push({ role: 'system', content: context }) if context.present?
    history.push(
      {
        role: 'user',
        content: prompt
      }
    )

    history
  end
end
