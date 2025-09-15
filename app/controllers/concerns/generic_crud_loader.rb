module GenericCrudLoader
  extend ActiveSupport::Concern

  included do
    helper_method :pagy, :records, :ransack
  end

  private

  def load_crud_records(model:, items: 10)
    ransack_params = fix_ransack_params(params[:q] || {})
    pagy_params = { page: params[:page] || 1, items: items }
    result = GenericCrudInteractor.call(
      model: model,
      action: :fetch,
      ransack_params: ransack_params,
      pagy_params: pagy_params
    )
    @pagy = result.pagy
    @records = result.records
    @ransack = model.ransack(ransack_params)
  end

  def pagy; @pagy; end
  def records; @records; end
  def ransack; @ransack; end
end

