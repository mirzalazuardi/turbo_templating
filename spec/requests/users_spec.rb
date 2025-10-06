# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe "GET /users" do
    it "returns http success" do
      get users_path
      expect(response).to have_http_status(:success)
    end

    it "loads users with pagination" do
      create_list(:user, 5)
      get users_path
      expect(response.body).to include("Users")
    end

    context "with turbo_stream format" do
      it "returns turbo_stream response" do
        get users_path, as: :turbo_stream
        expect(response.content_type).to include("text/vnd.turbo-stream.html")
      end
    end

    context "with json format" do
      it "returns json response" do
        get users_path, as: :json
        expect(response.content_type).to include("application/json")
      end
    end
  end

  describe "GET /users/new" do
    it "returns turbo_stream with form" do
      get new_user_path
      expect(response.content_type).to include("text/vnd.turbo-stream.html")
    end
  end

  describe "POST /users" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          user: {
            email: "newuser@example.com",
            password: "password123456"
          }
        }
      end

      xit "creates a new user" do
        expect {
          post users_path, params: valid_params
        }.to change(User, :count).by(1)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          user: {
            email: "invalid",
            password: "short"
          }
        }
      end

      it "does not create a user" do
        expect {
          post users_path, params: invalid_params
        }.not_to change(User, :count)
      end
    end
  end

  describe "GET /users/:id/edit" do
    let(:edit_user) { create(:user) }

    it "returns http success" do
      get edit_user_path(edit_user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /users/:id" do
    let(:edit_user) { create(:user) }

    context "with valid parameters" do
      let(:valid_params) do
        {
          user: {
            email: "updated@example.com"
          }
        }
      end

      it "updates the user" do
        patch user_path(edit_user), params: valid_params
        edit_user.reload
        expect(edit_user.email).to eq("updated@example.com")
      end

      it "redirects to users path" do
        patch user_path(edit_user), params: valid_params
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq("User updated")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          user: {
            email: "invalid"
          }
        }
      end

      it "returns unprocessable_entity status" do
        patch user_path(edit_user), params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /users/:id" do
    let!(:delete_user) { create(:user) }

    it "destroys the user" do
      expect {
        delete user_path(delete_user)
      }.to change(User, :count).by(-1)
    end

    it "redirects to users path" do
      delete user_path(delete_user)
      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to eq("User deleted")
    end
  end
end
