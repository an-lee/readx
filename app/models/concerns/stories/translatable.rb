# frozen_string_literal: true

module Stories::Translatable
  extend ActiveSupport::Concern

  def translate!(lang = 'zh-CN')
    return if locale == lang

    %i[title content summary].each do |attr|
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
    translations.find_or_create_by(key: :content, locale:)&.value || content
  end

  def title_in(locale = 'zh-CN')
    translations.find_or_create_by(key: :title, locale:)&.value || title
  end
end
