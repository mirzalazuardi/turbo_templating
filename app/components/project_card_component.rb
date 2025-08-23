# frozen_string_literal: true

class ProjectCardComponent < ViewComponent::Base
  def initialize(title:, client:)
    @title = title
    @client = client
  end
end
