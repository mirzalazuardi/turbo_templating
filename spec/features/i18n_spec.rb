# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Internationalization (i18n)", type: :request do
  let(:user) { create(:user, :verified) }

  before do
    sign_in(user)
  end

  describe "Default locale" do
    it "uses English as default locale" do
      get root_path
      expect(FastGettext.locale).to eq("en")
    end
  end

  describe "Locale switching via parameter" do
    it "switches to Indonesian when locale param is 'id'" do
      get root_path, params: { locale: "id" }
      expect(FastGettext.locale).to eq("id")
      expect(session[:locale]).to eq("id")
    end

    it "switches to English when locale param is 'en'" do
      get root_path, params: { locale: "en" }
      expect(FastGettext.locale).to eq("en")
      expect(session[:locale]).to eq("en")
    end

    it "persists locale in session" do
      get root_path, params: { locale: "id" }
      expect(session[:locale]).to eq("id")

      get root_path
      expect(FastGettext.locale).to eq("id")
    end
  end

  describe "Accept-Language header" do
    it "uses Indonesian from Accept-Language header" do
      get root_path, headers: { "HTTP_ACCEPT_LANGUAGE" => "id,en;q=0.9" }
      expect(FastGettext.locale).to eq("id")
    end

    it "uses English from Accept-Language header" do
      get root_path, headers: { "HTTP_ACCEPT_LANGUAGE" => "en,id;q=0.9" }
      expect(FastGettext.locale).to eq("en")
    end

    it "falls back to default when Accept-Language has unsupported language" do
      get root_path, headers: { "HTTP_ACCEPT_LANGUAGE" => "fr,de;q=0.9" }
      expect(FastGettext.locale).to eq("en")
    end
  end

  describe "Locale priority" do
    it "params > session > accept-language" do
      get root_path, params: { locale: "id" }
      expect(FastGettext.locale).to eq("id")

      get root_path, headers: { "HTTP_ACCEPT_LANGUAGE" => "en" }
      expect(FastGettext.locale).to eq("id") # Session takes precedence

      get root_path, params: { locale: "en" }
      expect(FastGettext.locale).to eq("en") # Params take precedence
    end
  end

  describe "Translation content" do
    context "in English" do
      before { get root_path, params: { locale: "en" } }

      it "translates navigation items" do
        FastGettext.locale = "en"
        expect(_("dashboard")).to eq("Dashboard")
        expect(_("projects")).to eq("Projects")
        expect(_("customers")).to eq("Customers")
      end

      it "translates user-related terms" do
        expect(_("users")).to eq("Users")
        expect(_("new_user")).to eq("New User")
        expect(_("email_address")).to eq("Email address")
      end

      it "translates common actions" do
        expect(_("save")).to eq("Save")
        expect(_("search")).to eq("Search")
        expect(_("cancel")).to eq("Cancel")
      end
    end

    context "in Indonesian" do
      before { get root_path, params: { locale: "id" } }

      it "translates navigation items" do
        FastGettext.locale = "id"
        expect(_("dashboard")).to eq("Dasbor")
        expect(_("projects")).to eq("Proyek")
        expect(_("customers")).to eq("Pelanggan")
      end

      it "translates user-related terms" do
        expect(_("users")).to eq("Pengguna")
        expect(_("new_user")).to eq("Pengguna Baru")
        expect(_("email_address")).to eq("Alamat email")
      end

      it "translates common actions" do
        expect(_("save")).to eq("Simpan")
        expect(_("search")).to eq("Cari")
        expect(_("cancel")).to eq("Batal")
      end
    end
  end

  describe "Available locales" do
    it "supports English and Indonesian" do
      expect(FastGettext.available_locales).to contain_exactly("en", "id")
    end

    it "has English as default" do
      expect(FastGettext.default_locale).to eq("en")
    end
  end
end
