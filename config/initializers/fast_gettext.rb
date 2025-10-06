# frozen_string_literal: true

FastGettext.add_text_domain("app", path: Rails.root.join("locale"), type: :po)
FastGettext.default_available_locales = ["en", "id"]
FastGettext.default_text_domain = "app"
FastGettext.default_locale = "en"
