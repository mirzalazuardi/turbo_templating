# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions::Omniauth", type: :request do
  describe "POST /auth/:provider/callback" do
    before do
      OmniAuth.config.test_mode = true
    end

    after do
      OmniAuth.config.test_mode = false
    end

    context "with valid Google OAuth credentials" do
      let(:auth_hash) do
        OmniAuth::AuthHash.new(
          provider: "google_oauth2",
          uid: "123456789",
          info: {
            email: "user@example.com",
            name: "Test User"
          }
        )
      end

      before do
        OmniAuth.config.add_mock(:google_oauth2, auth_hash)
      end

      context "when user does not exist" do
        it "creates a new user" do
          expect {
            post "/auth/google_oauth2/callback"
          }.to change(User, :count).by(1)
        end

        it "creates a session for the user" do
          expect {
            post "/auth/google_oauth2/callback"
          }.to change(Session, :count).by(1)
        end

        it "redirects to root path" do
          post "/auth/google_oauth2/callback"
          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to eq("Signed in successfully")
        end

        it "sets the user as verified" do
          post "/auth/google_oauth2/callback"
          user = User.find_by(email: "user@example.com")
          expect(user.verified).to be true
        end
      end

      context "when user already exists" do
        let!(:existing_user) do
          create(:user, provider: "google_oauth2", uid: "123456789", email: "user@example.com")
        end

        it "does not create a new user" do
          expect {
            post "/auth/google_oauth2/callback"
          }.not_to change(User, :count)
        end

        it "creates a new session for existing user" do
          expect {
            post "/auth/google_oauth2/callback"
          }.to change(Session, :count).by(1)
        end

        it "signs in the existing user" do
          post "/auth/google_oauth2/callback"
          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to eq("Signed in successfully")
        end
      end
    end

    context "with invalid credentials" do
      let(:invalid_auth_hash) do
        OmniAuth::AuthHash.new(
          provider: "google_oauth2",
          uid: "123456789",
          info: {
            email: nil # Invalid email
          }
        )
      end

      before do
        OmniAuth.config.add_mock(:google_oauth2, invalid_auth_hash)
      end

      it "does not create a user" do
        expect {
          post "/auth/google_oauth2/callback"
        }.not_to change(User, :count)
      end

      it "redirects to sign in with error" do
        post "/auth/google_oauth2/callback"
        expect(response).to redirect_to(sign_in_path)
        expect(flash[:alert]).to eq("Authentication failed")
      end
    end
  end

  describe "GET /auth/failure" do
    it "redirects to sign in path with error message" do
      get "/auth/failure", params: { message: "invalid_credentials" }
      expect(response).to redirect_to(sign_in_path)
      expect(flash[:alert]).to eq("invalid_credentials")
    end
  end
end
