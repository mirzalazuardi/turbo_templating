class SmartTableComponent < ViewComponent::Base
  include Pagy::Frontend
  include Ransack::Helpers::FormHelper

  def initialize(columns:, records:, ransack:, pagy:, result_frame_id:, search_predicates: {})
    @columns = columns
    @records = records
    @ransack = ransack
    @pagy = pagy
    @search_predicates = search_predicates
    @result_frame_id = result_frame_id
  end

  def search_field_name(column)
    predicate = @search_predicates[column] || "cont"
    "#{column}_#{predicate}"
  end
end
