class SmartTableComponent < ViewComponent::Base
  include Pagy::Frontend
  include Ransack::Helpers::FormHelper
  include ApplicationHelper

  def initialize(columns:, records:, ransack:, pagy:, result_frame_id:, search_predicates: {}, show_actions: false, model: nil, edit_path: nil, destroy_path: nil, inline_edit: false, inline_edit_columns: [], update_path: nil)
    @columns = columns
    @records = records
    @ransack = ransack
    @pagy = pagy
    @search_predicates = search_predicates
    @result_frame_id = result_frame_id
    @show_actions = show_actions
    @model = model
    @edit_path = edit_path
    @destroy_path = destroy_path
    @inline_edit = inline_edit
    @inline_edit_columns = inline_edit_columns
    @update_path = update_path
  end

  def search_field_name(column)
    predicate = @search_predicates[column] || "cont"
    "#{column}_#{predicate}"
  end

  def can_edit?(record)
    return false unless @model
    policy = Pundit.policy(Current.user, record)
    policy&.update?
  end

  def can_destroy?(record)
    return false unless @model
    policy = Pundit.policy(Current.user, record)
    policy&.destroy?
  end

  def edit_url(record)
    return nil unless @edit_path
    @edit_path.call(record)
  end

  def destroy_url(record)
    return nil unless @destroy_path
    @destroy_path.call(record)
  end

  def update_url(record)
    return nil unless @update_path
    @update_path.call(record)
  end

  def inline_editable?(column)
    @inline_edit && @inline_edit_columns.include?(column)
  end

  def edit_icon
    "Edit"
  end

  def delete_icon
    "Delete"
  end

  def tbody_classes
    "bg-white divide-y divide-gray-200"
  end

  def row_classes
    "hover:bg-gray-50 transition-colors duration-150"
  end

  def display_value(record, column)
    value = record.send(column)

    # Check if this is a foreign key column (ends with _id)
    if column.to_s.end_with?('_id')
      association_name = column.to_s.delete_suffix('_id')

      # Try to get the associated record
      if record.respond_to?(association_name)
        associated_record = record.send(association_name)
        return display_name_for(associated_record) if associated_record
      end
    end

    value
  end

  def display_name_for(record)
    return nil if record.nil?

    # Try common display attributes in order of preference
    [:name, :title, :email, :username, :full_name, :label, :display_name].each do |attr|
      return record.send(attr) if record.respond_to?(attr) && record.send(attr).present?
    end

    # Fallback to model name with ID
    "#{record.class.name} ##{record.id}"
  end
end
