# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:sessions).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value("user@example.com").for(:email) }
    it { should_not allow_value("invalid").for(:email) }
    it { should have_secure_password }

    context "password length validation" do
      it "validates minimum length of 12" do
        user = build(:user, password: "short", password_confirmation: "short")
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("is too short (minimum is 12 characters)")
      end

      it "accepts password with 12 characters" do
        user = build(:user, password: "password1234", password_confirmation: "password1234")
        expect(user).to be_valid
      end

      it "allows updating user without changing password" do
        user = create(:user)
        user.email = "newemail@example.com"
        # Don't set password - has_secure_password allows nil on update
        expect(user.save).to be true
      end
    end
  end

  describe "normalizations" do
    it "normalizes email to lowercase and strips whitespace" do
      user = build(:user, email: "  USER@EXAMPLE.COM  ")
      user.valid?
      expect(user.email).to eq("user@example.com")
    end
  end

  describe "callbacks" do
    describe "before_validation on update" do
      it "sets verified to false when email changes" do
        user = create(:user, :verified)
        expect(user.verified).to be true

        user.email = "newemail@example.com"
        user.valid?

        expect(user.verified).to be false
      end

      it "does not change verified when email does not change" do
        user = create(:user, :verified)
        expect(user.verified).to be true

        user.password = "newpassword1234"
        user.valid?

        expect(user.verified).to be true
      end
    end

    describe "after_update" do
      it "deletes other sessions when password is changed" do
        user = create(:user)
        session1 = create(:session, user: user)
        session2 = create(:session, user: user)
        current_session = create(:session, user: user)

        # Simulate Current.session being set
        allow(Current).to receive(:session).and_return(current_session.id)

        user.update(password: "newpassword1234", password_confirmation: "newpassword1234")

        expect(Session.exists?(session1.id)).to be false
        expect(Session.exists?(session2.id)).to be false
        expect(Session.exists?(current_session.id)).to be true
      end
    end
  end

  describe ".from_omniauth" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "123456",
        info: {
          email: "oauth@example.com",
          name: "OAuth User"
        }
      )
    end

    context "when user exists" do
      let!(:existing_user) { create(:user, provider: "google_oauth2", uid: "123456") }

      it "returns the existing user" do
        user = User.from_omniauth(auth)
        expect(user).to eq(existing_user)
        expect(user).to be_persisted
      end
    end

    context "when user does not exist" do
      it "initializes a new user with oauth data" do
        user = User.from_omniauth(auth)
        expect(user).to be_new_record
        expect(user.email).to eq("oauth@example.com")
        expect(user.provider).to eq("google_oauth2")
        expect(user.uid).to eq("123456")
        expect(user.password_digest).to be_present
      end
    end
  end

  describe ".ransackable_attributes" do
    it "returns searchable attributes" do
      expect(User.ransackable_attributes).to match_array(%w[id email provider uid created_at updated_at])
    end
  end

  describe "token generation" do
    let(:user) { create(:user, email: "test@example.com") }

    it "generates email verification token" do
      token = user.generate_token_for(:email_verification)
      expect(token).to be_present
    end

    it "generates password reset token" do
      token = user.generate_token_for(:password_reset)
      expect(token).to be_present
    end
  end
end
