# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /sessions" do
    context "when authenticated" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      it "returns http success" do
        get sessions_path
        expect(response).to have_http_status(:success)
      end

      it "displays user sessions list" do
        get sessions_path
        expect(response.body).to include("Sessions")
      end
    end

    context "when not authenticated" do
      it "redirects to sign in" do
        get sessions_path
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end

  describe "GET /sign_in" do
    it "returns http success" do
      get sign_in_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /sign_in" do
    let(:user) { create(:user, email: "test@example.com", password: "password123456") }

    context "with valid credentials" do
      it "creates a session and redirects to root" do
        post sign_in_path, params: { email: user.email, password: "password123456" }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Signed in successfully")
      end
    end

    context "with invalid credentials" do
      it "redirects back to sign in with error" do
        post sign_in_path, params: { email: user.email, password: "wrongpassword" }

        expect(response).to redirect_to(sign_in_path(email_hint: user.email))
        expect(flash[:alert]).to eq("That email or password is incorrect")
      end
    end
  end

  describe "DELETE /sessions/:id" do
    let(:user) { create(:user) }
    let(:other_session) { create(:session, user: user) }

    before do
      sign_in(user)
    end

    xit "destroys the session" do
      expect {
        delete session_path(other_session)
      }.to change(Session, :count).by(-1)

      expect(response).to redirect_to(sessions_path)
      expect(flash[:notice]).to eq("That session has been logged out")
    end
  end
end
