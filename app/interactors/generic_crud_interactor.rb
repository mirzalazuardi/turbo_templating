class GenericCrudInteractor
  include Interactor

  # context expects:
  # :model (ActiveRecord class)
  # :action (:create, :read, :update, :delete, :fetch)
  # :params (hash for create/update)
  # :id (for read/update/delete)
  # :ransack_params (hash for ransack search/sort)
  # :pagy_params (hash: {page:, items:})
  # :cache_key (optional, for fetch)
  # :expires_in (optional, for fetch cache)
  # :format (optional, :json, :turbo_stream, :html, etc.)

  def call
    case context.action
    when :create
      create_record
    when :read
      read_record
    when :update
      update_record
    when :delete
      delete_record
    when :fetch
      fetch_records
    else
      context.fail!(error: "Unknown action")
    end
  rescue => e
    context.fail!(error: e.message)
  end

  private

  def create_record
    record = context.model.new(context.params)
    if record.save
      context.record = format_record(record)
    else
      context.fail!(error: record.errors.full_messages.to_sentence)
    end
  end

  def read_record
    record = context.model.find_by(id: context.id)
    if record
      context.record = format_record(record)
    else
      context.fail!(error: "Record not found")
    end
  end

  def update_record
    record = context.model.find_by(id: context.id)
    if record&.update(context.params)
      context.record = format_record(record)
    else
      context.fail!(error: record ? record.errors.full_messages.to_sentence : "Record not found")
    end
  end

  def delete_record
    record = context.model.find_by(id: context.id)
    if record&.destroy
      context.record = format_record(record)
    else
      context.fail!(error: record ? record.errors.full_messages.to_sentence : "Record not found")
    end
  end

  def fetch_records
    key = context.cache_key || default_cache_key
    context.pagy, context.records = Rails.cache.fetch(key, expires_in: context.expires_in || 5.minutes) do
      scope = context.model.all
      if context.ransack_params.present?
        ransack_search = scope.ransack(context.ransack_params)
        scope = ransack_search.result
      end
      pagy, records = if defined?(Pagy)
        pagy_obj, pagy_records = Pagy.new(count: scope.count, page: pagy_page, items: pagy_items), scope.offset((pagy_page - 1) * pagy_items).limit(pagy_items)
        [pagy_obj, pagy_records]
      else
        [nil, scope]
      end
      [pagy, format_records(records)]
    end
  end

  def pagy_page
    (context.dig(:pagy_params, :page) || 1).to_i
  end

  def pagy_items
    (context.dig(:pagy_params, :items) || 20).to_i
  end

  def default_cache_key
    [
      context.model.name,
      "page:#{pagy_page}",
      "items:#{pagy_items}",
      "ransack:#{context.ransack_params&.to_param}",
      "format:#{context.format}"
    ].compact.join("/")
  end

  def format_record(record)
    case context.format
    when :json
      record.as_json
    when :turbo_stream
      ApplicationController.render(record)
    else
      record
    end
  end

  def format_records(records)
    case context.format
    when :json
      records.map(&:as_json)
    when :turbo_stream
      ApplicationController.render(records)
    else
      records
    end
  end
end
