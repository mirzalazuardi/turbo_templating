# Internationalization (i18n) Guide

## Overview

This application uses **fast_gettext** for internationalization, supporting English (default) and Indonesian languages.

## Supported Languages

- 🇺🇸 **English (en)** - Default language
- 🇮🇩 **Indonesian (id)** - Bahasa Indonesia

## Configuration

### Initializer

Located at `config/initializers/fast_gettext.rb`:

```ruby
FastGettext.add_text_domain("app", path: Rails.root.join("locale"), type: :po)
FastGettext.default_available_locales = ["en", "id"]
FastGettext.default_text_domain = "app"
FastGettext.default_locale = "en"
```

### Application Controller

The locale is automatically set based on:
1. **URL parameter** (`?locale=id`)
2. **Session** (persisted from previous selection)
3. **Accept-Language header** (browser language)
4. **Default locale** (en)

## Using Translations

### In Views (ERB)

Use the `_()` method to translate strings:

```erb
<h1><%= _("dashboard") %></h1>
<p><%= _("welcome_message") %></p>
```

### In Controllers

Include `FastGettext::Translation` (already done in ApplicationController):

```ruby
flash[:notice] = _("user_created_successfully")
```

### In ViewComponents

Components automatically have access to translation methods:

```ruby
class MyComponent < ViewComponent::Base
  def render
    content_tag :h1, _("title")
  end
end
```

### With Variables

```ruby
_("hello_name|Hello %{name}!") % { name: user.name }
```

## Adding New Translations

### 1. Update PO Files

Edit the translation files:

**English** (`locale/en/app.po`):
```po
msgid "new_feature"
msgstr "New Feature"
```

**Indonesian** (`locale/id/app.po`):
```po
msgid "new_feature"
msgstr "Fitur Baru"
```

### 2. Translation File Format

Each translation entry follows this format:

```po
# Optional comment
msgid "translation_key"
msgstr "Translated text"
```

### 3. Plural Forms

**English** (2 forms):
```po
msgid "item"
msgid_plural "items"
msgstr[0] "%{count} item"
msgstr[1] "%{count} items"
```

**Indonesian** (1 form - no pluralization):
```po
msgid "item"
msgid_plural "items"
msgstr[0] "%{count} item"
```

## Locale Switcher

The application includes a locale switcher in the header (`LocaleSwitcherComponent`):

- Displays current language with flag
- Dropdown menu for language selection
- Persists selection in session
- Available on all pages

### Usage

Users can switch languages by:
1. Clicking the language selector in the header
2. Selecting their preferred language from the dropdown
3. Adding `?locale=id` or `?locale=en` to any URL

## Testing Translations

### Request Specs

```ruby
describe "in Indonesian" do
  before { get root_path, params: { locale: "id" } }

  it "displays Indonesian text" do
    expect(response.body).to include("Dasbor") # Indonesian for "Dashboard"
  end
end
```

### Component Specs

```ruby
it "returns correct translation" do
  FastGettext.locale = "id"
  expect(_("dashboard")).to eq("Dasbor")
end
```

## Common Translation Keys

### Navigation
- `dashboard` - Dashboard / Dasbor
- `projects` - Projects / Proyek
- `customers` - Customers / Pelanggan
- `invoices` - Invoices / Faktur
- `support` - Support / Dukungan
- `settings` - Settings / Pengaturan
- `logout` - Logout / Keluar

### User Management
- `users` - Users / Pengguna
- `new_user` - New User / Pengguna Baru
- `edit_user` - Edit User / Ubah Pengguna
- `email_address` - Email address / Alamat email

### Actions
- `save` - Save / Simpan
- `search` - Search / Cari
- `cancel` - Cancel / Batal
- `delete` - Delete / Hapus
- `edit` - Edit / Ubah

### Authentication
- `sign_in` - Sign in / Masuk
- `sign_up` - Sign up / Daftar
- `password` - Password / Kata sandi
- `forgot_password` - Forgot your password? / Lupa kata sandi?

## Best Practices

### 1. Use Descriptive Keys

❌ **Bad:**
```ruby
_("btn1")  # What does btn1 mean?
```

✅ **Good:**
```ruby
_("save_button")  # Clear and descriptive
```

### 2. Keep Keys Consistent

Use consistent naming patterns:
- Actions: `save`, `delete`, `edit`
- Labels: `email_address`, `password`
- Messages: `user_created_successfully`

### 3. Avoid Hardcoded Strings

❌ **Bad:**
```erb
<h1>Dashboard</h1>
```

✅ **Good:**
```erb
<h1><%= _("dashboard") %></h1>
```

### 4. Extract Long Texts

For longer texts, use separate keys:

```po
msgid "welcome_message_long"
msgstr "Welcome to our application. We're glad you're here. Feel free to explore all features."
```

### 5. Context Matters

Add comments for translators:

```po
# Used in navigation menu
msgid "home"
msgstr "Home"

# Used in breadcrumbs
msgid "home_breadcrumb"
msgstr "Home"
```

## Adding a New Language

### 1. Create Locale Directory

```bash
mkdir -p locale/[language_code]
```

### 2. Create PO File

```bash
touch locale/[language_code]/app.po
```

### 3. Update Initializer

```ruby
FastGettext.default_available_locales = ["en", "id", "[language_code]"]
```

### 4. Add to Locale Switcher

Edit `app/components/locale_switcher_component.rb`:

```ruby
def available_locales
  [
    { code: "en", name: _("english"), flag: "🇺🇸" },
    { code: "id", name: _("indonesian"), flag: "🇮🇩" },
    { code: "[code]", name: _("language_name"), flag: "🏳️" }
  ]
end
```

### 5. Add Translations

Copy entries from `locale/en/app.po` and translate to the new language.

## Debugging

### Check Current Locale

```ruby
FastGettext.locale  # Returns current locale code
```

### List Available Locales

```ruby
FastGettext.available_locales  # ["en", "id"]
```

### Test Translation

```ruby
_("dashboard")  # Returns translated string
```

### View Missing Translations

Missing translations will return the msgid (key) itself:

```ruby
_("nonexistent_key")  # => "nonexistent_key"
```

## File Structure

```
locale/
├── en/
│   └── app.po          # English translations
└── id/
    └── app.po          # Indonesian translations
```

## Resources

- [fast_gettext Documentation](https://github.com/grosser/fast_gettext)
- [gettext_i18n_rails Documentation](https://github.com/grosser/gettext_i18n_rails)
- [GNU gettext Manual](https://www.gnu.org/software/gettext/manual/)
- [Rails i18n Guide](https://guides.rubyonrails.org/i18n.html)

## Testing

Run i18n specs:

```bash
bin/rspec spec/features/i18n_spec.rb
```

Run all specs:

```bash
bin/rspec
```

## Examples

### View Example

```erb
<nav>
  <%= link_to _("dashboard"), dashboard_path %>
  <%= link_to _("users"), users_path %>
  <%= link_to _("settings"), settings_path %>
</nav>
```

### Controller Example

```ruby
def create
  if @user.save
    redirect_to @user, notice: _("user_created_successfully")
  else
    flash.now[:alert] = _("user_creation_failed")
    render :new
  end
end
```

### Component Example

```ruby
class AlertComponent < ViewComponent::Base
  def initialize(type:, message:)
    @type = type
    @message = message
  end

  def icon
    case @type
    when :success
      _("success")
    when :error
      _("error")
    end
  end
end
```

## Maintenance

### Updating Translations

1. Edit `.po` files
2. Restart the server to load new translations
3. Test in both languages
4. Commit changes

### Syncing Translations

To find missing translations, compare PO files:

```bash
# Count translations in each file
grep -c "msgid" locale/en/app.po
grep -c "msgid" locale/id/app.po
```

The counts should match to ensure all keys are translated.

Happy translating! 🌍
