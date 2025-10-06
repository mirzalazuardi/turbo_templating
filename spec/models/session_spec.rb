# frozen_string_literal: true

require "rails_helper"

RSpec.describe Session, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "callbacks" do
    describe "before_create" do
      it "sets user_agent and ip_address from Current" do
        user = create(:user)

        allow(Current).to receive(:user_agent).and_return("Test User Agent")
        allow(Current).to receive(:ip_address).and_return("192.168.1.1")

        session = Session.create(user: user)

        expect(session.user_agent).to eq("Test User Agent")
        expect(session.ip_address).to eq("192.168.1.1")
      end
    end
  end
end
