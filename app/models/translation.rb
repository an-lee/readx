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
    Keep the name of the entity, like person, place, organization, etc. unchanged. \
    Return the translated text only, no other words needed.
  CONTEXT
  TRANSLATE_PROMPT_TEMPLATE = <<~PROMPT
    Translate the text to {locale}. The text is delimited by four backticks.

    Text:
    ````{text}````
  PROMPT

  belongs_to :translatable, polymorphic: true, touch: true

  has_many :llm_messages, as: :source, dependent: nil

  after_commit :translate_async, on: :create

  scope :for_locale, ->(locale) { where(locale:) }
  scope :untranslated, -> { where(value: nil) }
  scope :translated, -> { where.not(value: nil) }

  def language
    {
      'zh-CN': 'Simplified Chinese',
      en: 'English'
    }[locale.to_sym]
  end

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
      value: llm_message.result.gsub('````', '').strip
    )

    translatable.translate! if translatable.is_a?(Story) && translatable.may_translate?
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
      prompt: llm_translate_prompt.format(locale: language, text: original_text.truncate(8_000))
    )
  end
end
