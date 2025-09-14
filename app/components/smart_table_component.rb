class SmartTableComponent < ViewComponent::Base
  include Pagy::Frontend
  include Ransack::Helpers::FormHelper

  def initialize(columns:, records:, ransack:, pagy:, search_predicates: {})
    @columns = columns
    @records = records
    @ransack = ransack
    @pagy = pagy
    @search_predicates = search_predicates
  end

  def search_field_name(column)
    predicate = @search_predicates[column] || "cont"
    "#{column}_#{predicate}"
  end
end
