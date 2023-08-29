# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Localizable
  include Pagy::Backend

  helper_method :current_locale
  helper_method :from_mixin_messenger?

  def with_locale(&)
    locale = current_locale&.to_sym || I18n.default_locale
    I18n.with_locale(locale, &)
  end

  def current_locale
    @current_locale ||= (session[:current_locale].presence || browser_locale.presence || I18n.default_locale)
  end

  def from_mixin_messenger?
    request&.user_agent&.match?(/Mixin/)
  end
end
