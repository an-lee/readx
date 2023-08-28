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

  def summary
    @summary ||=
      if I18n.locale == locale
        super
      else
        translations.find_or_create_by(key: :summary, locale: I18n.locale)&.value || super
      end
  end

  def content
    @content ||=
      if I18n.locale == locale
        super
      else
        translations.find_or_create_by(key: :content, locale: I18n.locale)&.value || super
      end
  end

  def title
    @title ||=
      if I18n.locale == locale
        super
      else
        translations.find_or_create_by(key: :title, locale: I18n.locale)&.value&.gsub(/。\Z/, '') || super
      end
  end
end
