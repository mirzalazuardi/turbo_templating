# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /index" do
    context "when authenticated" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      it "returns http success" do
        get root_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when not authenticated" do
      it "redirects to sign in" do
        get root_path
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end
