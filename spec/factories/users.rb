# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123456" }
    password_confirmation { "password123456" }
    verified { false }

    trait :verified do
      verified { true }
    end

    trait :with_omniauth do
      provider { "google_oauth2" }
      sequence(:uid) { |n| "12345#{n}" }
    end
  end
end
