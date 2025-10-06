# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Passwords", type: :request do
  let(:user) { create(:user, password: "oldpassword123") }

  before do
    sign_in(user)
  end

  describe "GET /password/edit" do
    xit "returns http success" do
      get edit_password_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT /password" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          password: "newpassword1234",
          password_confirmation: "newpassword1234",
          password_challenge: "oldpassword123"
        }
      end

      xit "updates the password" do
        put password_path, params: valid_params
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Your password has been changed")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          password: "short",
          password_confirmation: "short",
          password_challenge: ""
        }
      end

      xit "returns unprocessable_entity status" do
        put password_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
