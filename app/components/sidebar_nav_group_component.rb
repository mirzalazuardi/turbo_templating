# frozen_string_literal: true

class SidebarNavGroupComponent < ViewComponent::Base
  def initialize(label:)
    @label = label
  end
end
