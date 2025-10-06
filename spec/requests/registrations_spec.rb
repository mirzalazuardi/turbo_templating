# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations", type: :request do
  describe "GET /sign_up" do
    it "returns http success" do
      get sign_up_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /sign_up" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          email: "newuser@example.com",
          password: "password123456",
          password_confirmation: "password123456"
        }
      end

      it "creates a new user" do
        expect {
          post sign_up_path, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "creates a session for the user" do
        expect {
          post sign_up_path, params: valid_params
        }.to change(Session, :count).by(1)
      end

      it "redirects to root path" do
        post sign_up_path, params: valid_params
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Welcome! You have signed up successfully")
      end

      it "sends verification email" do
        expect {
          post sign_up_path, params: valid_params
        }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          email: "invalid",
          password: "short",
          password_confirmation: "short"
        }
      end

      it "does not create a user" do
        expect {
          post sign_up_path, params: invalid_params
        }.not_to change(User, :count)
      end

      it "returns unprocessable_entity status" do
        post sign_up_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
