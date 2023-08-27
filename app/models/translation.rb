# frozen_string_literal: true

# == Schema Information
#
# Table name: translations
#
#  id                :uuid             not null, primary key
#  key               :string           not null
#  locale            :string           not null
#  translatable_type :string           not null
#  value             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  translatable_id   :uuid             not null
#
# Indexes
#
#  index_translations_on_locale                           (locale)
#  index_translations_on_translatable_and_locale_and_key  (translatable_id,translatable_type,locale,key) UNIQUE
#
class Translation < ApplicationRecord
  TRANSLATE_CONTEXT = <<~CONTEXT
    You are a translator at a cryptocurrency news website. You are responsible for translating the material to {locale} from any other languages. Make it clean, concise and easy to understand. Return the translated content directly, no other words are needed.
  CONTEXT

  belongs_to :translatable, polymorphic: true
  has_many :llm_messages, as: :source, dependent: nil

  def translate!
    return value if value.present?

    llm_message.chat if llm_message.pending?
    update!(
      value: llm_message.response
    )
  end

  def llm_translate_context
    @llm_translate_context ||=
      Langchain::Prompt::PromptTemplate.new(
        template: TRANSLATE_CONTEXT,
        input_variables: %w[locale]
      )
  end

  def llm_message
    @llm_message ||= llm_messages.first || llm_messages.create!(
      llm_message_type: 'translate',
      context: llm_translate_context.format(locale:),
      prompt: translatable.send(key)
    )
  end
end
