# frozen_string_literal: true

class CustomerCardComponent < ViewComponent::Base
  def initialize(name:, email:, project:)
    @name = name
    @email = email
    @project = project
  end
end
