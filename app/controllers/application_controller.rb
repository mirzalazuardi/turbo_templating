class ApplicationController < ActionController::Base
  include Pundit::Authorization

  include Pagy::Backend
  include Pagy::Frontend

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_request_details
  before_action :authenticate

  def fix_ransack_params(ransack_params)
    ransack_params.permit(*ransack_params.keys).to_h if ransack_params.kind_of?(ActionController::Parameters)
  end

  private
    def authenticate
      if session_record = Session.find_by_id(cookies.signed[:session_token])
        Current.session = session_record
      else
        redirect_to sign_in_path
      end
    end

    def set_current_request_details
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end
end
