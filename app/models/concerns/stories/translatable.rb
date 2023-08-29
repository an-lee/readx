# frozen_string_literal: true

module Stories::Translatable
  extend ActiveSupport::Concern

  def translate_async(lang = 'zh-CN')
    return if locale == lang

    %i[title content summary].each do |attr|
      translations.find_or_create_by!(
        key: attr,
        locale: lang
      )
    end
  end

  def all_translated?
    %i[title summary].all? do |attr|
      translations.translated.exists?(key: attr)
    end
  end

  included do
    %i[title summary content].each do |attr_name|
      define_method "#{attr_name}_text" do
        if I18n.locale == locale
          send attr_name
        else
          translations.find_or_create_by(key: attr_name, locale: I18n.locale)&.value || send(attr_name)
        end
      end
    end
  end
end
