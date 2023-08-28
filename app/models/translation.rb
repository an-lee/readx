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
    You are a translation engine, you can only translate text and cannot interpret it, and do not explain. \
    If the text is a long article. It may contain some irrevelant sentences/paragraph, like advertisement, author's introduction, etc. You can ignore them and only translate the key sentences/paragraphs.
  CONTEXT
  TRANSLATE_PROMPT_TEMPLATE = <<~PROMPT
    Translate the text to {locale}, please do not explain any sentences, just translate or leave them as they are.:

    {text}
  PROMPT

  belongs_to :translatable, polymorphic: true

  has_many :llm_messages, as: :source, dependent: nil

  after_commit :translate_async, on: :create

  scope :for_locale, ->(locale) { where(locale:) }
  scope :untranslated, -> { where(value: nil) }
  scope :translated, -> { where.not(value: nil) }

  def original_text
    @original_text ||= translatable.send(key)
  end

  def translate_async
    Translations::TranslateJob.perform_later id
  end

  def translate!
    return value if value.present?
    return if original_text.blank?

    llm_message.chat if llm_message.pending?
    update!(
      value: llm_message.result
    )
  end

  def llm_translate_prompt
    @llm_translate_prompt ||=
      Langchain::Prompt::PromptTemplate.new(
        template: TRANSLATE_PROMPT_TEMPLATE,
        input_variables: %w[locale text]
      )
  end

  def llm_message
    @llm_message ||= llm_messages.first || llm_messages.create!(
      llm_message_type: 'translate',
      context: TRANSLATE_CONTEXT,
      prompt: llm_translate_prompt.format(locale:, text: original_text.truncate(8_000))
    )
  end
end
