class SmartTableComponent < ViewComponent::Base
  def initialize(columns:, records:, ransack:, pagy:)
    @columns = columns
    @records = records
    @ransack = ransack
    @pagy = pagy
  end
end
