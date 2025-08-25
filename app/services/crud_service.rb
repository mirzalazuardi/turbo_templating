class CrudService
  include Pagy::Backend

  attr_reader :model

  def initialize(model, use_cache: nil)
    @model = model
    @use_cache = use_cache.nil? ? Rails.env.production? : use_cache
  end

  # Find one record
  def find(id, cache_key: nil)
    if @use_cache
      key = cache_key || default_find_key(id)
      Rails.cache.fetch(key, expires_in: 15.minutes) do
        model.find_by(id: id)
      end
    else
      model.find_by(id: id)
    end
  end

  # List with pagination
  # Returns: [pagy, records]
  def list(scope: nil, cache_key: nil, page: nil, items: nil, **conditions)
    base_scope = scope || model.all
    scoped_query = conditions.present? ? base_scope.where(conditions) : base_scope

    # Apply order to avoid inconsistent pagination
    ordered_query = ensure_ordered(scoped_query)

    # Build cache key early if needed
    if @use_cache
      key = cache_key || default_list_key(ordered_query, page: page, items: items)
      Rails.cache.fetch(key, expires_in: 15.minutes) do
        pagy(ordered_query, page: page, items: items)
      end
    else
      pagy(ordered_query, page: page, items: items)
    end
  end

  def create(attributes)
    record = model.create!(attributes)
    expire_cache_for_model
    record
  rescue ActiveRecord::RecordInvalid => e
    raise ServiceError, "Create failed: #{e.message}"
  end

  def update(id, attributes, cache_key: nil)
    record = find_record_for_update(id)
    return nil unless record

    record.update!(attributes)

    # Expire caches
    key = cache_key || default_find_key(id)
    Rails.cache.delete(key)
    expire_cache_for_model

    record
  rescue ActiveRecord::RecordInvalid => e
    raise ServiceError, "Update failed: #{e.message}"
  end

  def destroy(id, cache_key: nil)
    record = find_record_for_update(id)
    return false unless record

    result = record.destroy!

    # Clear caches
    key = cache_key || default_find_key(id)
    Rails.cache.delete(key)
    expire_cache_for_model

    result
  end

  private

  # Ensure query has deterministic order (critical for pagination)
  def ensure_ordered(relation)
    return relation if relation.order_values.any?

    # Default fallback: order by primary key
    relation.order(id: :asc)
  end

  # Paginate using Pagy backend
  def pagy(query, page: nil, items: nil)
    # Use params or defaults
    page  = page.try(:to_i) || 1
    items = items.try(:to_i) || Pagy::VARS[:items]

    # Create Pagy instance
    pagy = Pagy.new(count: query.count, page: page, items: items)
    # Fetch only the needed records
    records = query.limit(pagy.limit).offset(pagy.offset)

    [pagy, records]
  end

  def find_record_for_update(id)
    @use_cache ? model.uncached { model.find_by(id: id) } : model.find_by(id: id)
  end

  def default_find_key(id)
    "crud/#{model.name.underscore}/#{id}"
  end

  def default_list_key(relation, page: nil, items: nil)
    query_sql = relation.select(:id).order_values.any? ? relation.to_sql : relation.reorder(id: :asc).to_sql
    fingerprint = Digest::MD5.hexdigest("#{query_sql}|page:#{page}|items:#{items}")
    "crud/#{model.name.underscore}/list/#{fingerprint}"
  end

  def expire_cache_for_model
    Rails.cache.delete_matched("crud/#{model.name.underscore}/*") # or use tagging if Redis
  end

  class ServiceError < StandardError; end
end
