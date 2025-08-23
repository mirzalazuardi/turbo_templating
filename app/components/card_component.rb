# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  def initialize(title:, value:, subtitle:)
    @title = title
    @value = value
    @subtitle = subtitle
  end
end
