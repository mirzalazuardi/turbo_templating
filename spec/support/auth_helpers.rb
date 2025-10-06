# frozen_string_literal: true

module AuthHelpers
  def sign_in(user)
    # Create session
    session_record = user.sessions.create!(
      user_agent: "Test User Agent",
      ip_address: "127.0.0.1"
    )

    # Stub the authenticate method to set Current.session
    allow_any_instance_of(ApplicationController).to receive(:authenticate) do
      Current.session = session_record
    end

    session_record
  end
end
