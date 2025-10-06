# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Progressive Web App (PWA)", type: :request do
  describe "GET /manifest.json" do
    it "serves the web app manifest" do
      get "/manifest.json"
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("application/json")
    end

    it "contains valid manifest data" do
      get "/manifest.json"
      manifest = JSON.parse(response.body)

      expect(manifest["name"]).to eq("Turbo Templating")
      expect(manifest["short_name"]).to eq("TurboApp")
      expect(manifest["display"]).to eq("standalone")
      expect(manifest["start_url"]).to eq("/")
      expect(manifest["theme_color"]).to be_present
      expect(manifest["background_color"]).to be_present
    end

    it "includes app icons" do
      get "/manifest.json"
      manifest = JSON.parse(response.body)

      expect(manifest["icons"]).to be_an(Array)
      expect(manifest["icons"].length).to be >= 2

      icon_192 = manifest["icons"].find { |i| i["sizes"] == "192x192" }
      icon_512 = manifest["icons"].find { |i| i["sizes"] == "512x512" }

      expect(icon_192).to be_present
      expect(icon_512).to be_present
      expect(icon_192["src"]).to eq("/icon-192.png")
      expect(icon_512["src"]).to eq("/icon-512.png")
    end

    it "includes shortcuts" do
      get "/manifest.json"
      manifest = JSON.parse(response.body)

      expect(manifest["shortcuts"]).to be_an(Array)
      expect(manifest["shortcuts"].length).to be > 0
    end
  end

  describe "GET /service-worker.js" do
    it "serves the service worker file" do
      get "/service-worker.js"
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("text/javascript")
    end

    it "contains service worker registration code" do
      get "/service-worker.js"

      expect(response.body).to include("self.addEventListener")
      expect(response.body).to include("install")
      expect(response.body).to include("activate")
      expect(response.body).to include("fetch")
    end

    it "includes cache management" do
      get "/service-worker.js"

      expect(response.body).to include("CACHE_VERSION")
      expect(response.body).to include("caches.open")
      expect(response.body).to include("cache.put")
    end
  end

  describe "GET /offline.html" do
    it "serves the offline fallback page" do
      get "/offline.html"
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("text/html")
    end

    it "contains offline message" do
      get "/offline.html"

      expect(response.body).to include("Offline")
      expect(response.body).to include("internet connection")
    end

    it "includes retry functionality" do
      get "/offline.html"

      expect(response.body).to include("Try Again")
      expect(response.body).to include("location.reload")
    end
  end

  describe "PWA Icons" do
    it "serves icon-192.png" do
      get "/icon-192.png"
      expect(response).to have_http_status(:success)
    end

    it "serves icon-512.png" do
      get "/icon-512.png"
      expect(response).to have_http_status(:success)
    end

    it "serves icon.svg" do
      get "/icon.svg"
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include("image/svg+xml")
    end
  end

  describe "Application Layout PWA Meta Tags" do
    before do
      # Create a test user and sign in for authenticated pages
      user = create(:user)
      sign_in(user)
    end

    it "includes web app manifest link" do
      get root_path
      expect(response.body).to include('rel="manifest"')
      expect(response.body).to include('/manifest.json')
    end

    it "includes apple-touch-icon" do
      get root_path
      expect(response.body).to include('rel="apple-touch-icon"')
      expect(response.body).to include('icon-192.png')
    end

    it "includes theme-color meta tag" do
      get root_path
      expect(response.body).to include('name="theme-color"')
      expect(response.body).to include('#3b82f6')
    end

    it "includes apple-mobile-web-app-capable" do
      get root_path
      expect(response.body).to include('name="apple-mobile-web-app-capable"')
      expect(response.body).to include('content="yes"')
    end

    it "includes viewport meta tag with viewport-fit" do
      get root_path
      expect(response.body).to include('name="viewport"')
      expect(response.body).to include('viewport-fit=cover')
    end

    it "includes application name" do
      get root_path
      expect(response.body).to include('name="application-name"')
      expect(response.body).to include('Turbo Templating')
    end
  end

  describe "PWA JavaScript" do
    it "includes pwa.js in the JavaScript bundle" do
      # Check that pwa.js is imported in application.js
      app_js = File.read(Rails.root.join("app/javascript/application.js"))
      expect(app_js).to include('import "./pwa"')
    end
  end

  describe "Manifest Validation" do
    let(:manifest) { JSON.parse(File.read(Rails.root.join("public/manifest.json"))) }

    it "has required manifest fields" do
      required_fields = %w[name short_name start_url display icons]
      required_fields.each do |field|
        expect(manifest[field]).to be_present, "Manifest missing required field: #{field}"
      end
    end

    it "has valid display mode" do
      valid_modes = %w[fullscreen standalone minimal-ui browser]
      expect(valid_modes).to include(manifest["display"])
    end

    it "has valid orientation" do
      if manifest["orientation"]
        valid_orientations = %w[any natural landscape portrait portrait-primary portrait-secondary landscape-primary landscape-secondary]
        expect(valid_orientations).to include(manifest["orientation"])
      end
    end

    it "has valid icon sizes" do
      manifest["icons"].each do |icon|
        expect(icon["sizes"]).to match(/^\d+x\d+$/)
        expect(icon["src"]).to be_present
        expect(icon["type"]).to be_present
      end
    end

    it "has hex color values" do
      if manifest["theme_color"]
        expect(manifest["theme_color"]).to match(/^#[0-9a-fA-F]{6}$/)
      end

      if manifest["background_color"]
        expect(manifest["background_color"]).to match(/^#[0-9a-fA-F]{6}$/)
      end
    end
  end

  describe "Service Worker Validation" do
    let(:service_worker) { File.read(Rails.root.join("public/service-worker.js")) }

    it "has install event listener" do
      expect(service_worker).to include("addEventListener('install'")
    end

    it "has activate event listener" do
      expect(service_worker).to include("addEventListener('activate'")
    end

    it "has fetch event listener" do
      expect(service_worker).to include("addEventListener('fetch'")
    end

    it "has cache versioning" do
      expect(service_worker).to match(/CACHE_VERSION\s*=\s*['"]/)
      expect(service_worker).to match(/CACHE_NAME\s*=/)
    end

    it "handles GET requests only" do
      expect(service_worker).to include("request.method !== 'GET'")
    end

    it "has offline fallback logic" do
      expect(service_worker).to include("catch")
      expect(service_worker).to include("caches.match")
    end
  end
end
