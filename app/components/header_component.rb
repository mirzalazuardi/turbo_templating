# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  def initialize(mobile_sidebar_open: true)
    @mobile_sidebar_open = mobile_sidebar_open
  end
end
