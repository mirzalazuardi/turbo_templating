class PagyTailwindComponent < ViewComponent::Base
  attr_reader :pagy

  def initialize(pagy:)
    @pagy = pagy
  end

  # Hanya render jika ada lebih dari 1 halaman
  def render?
    pagy && pagy.pages > 1
  end

  # Helper method untuk URL
  def page_url(page)
    pagy_url_for(pagy, page)
  end

  private

  # Include helper Pagy::Frontend agar bisa pakai pagy_url_for
  include Pagy::Frontend
end
