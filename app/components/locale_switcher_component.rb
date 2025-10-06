# frozen_string_literal: true

class LocaleSwitcherComponent < ViewComponent::Base
  def initialize
    @current_locale = FastGettext.locale
  end

  def available_locales
    [
      { code: "en", name: _("english"), flag: "🇺🇸" },
      { code: "id", name: _("indonesian"), flag: "🇮🇩" }
    ]
  end

  def current_locale_info
    available_locales.find { |l| l[:code] == @current_locale }
  end
end
