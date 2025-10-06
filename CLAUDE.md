# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rails 8.0 application with a modern Hotwire (Turbo + Stimulus) stack, ViewComponents architecture, and a generic CRUD pattern using Interactors. The app uses PostgreSQL with solid_cache, solid_cable, and solid_queue for Rails 8 features.

## Working Features

### Authentication & User Management
- ✅ User registration with email/password
- ✅ Email verification system (generates_token_for)
- ✅ Password reset functionality
- ✅ Session management (view/delete sessions)
- ✅ OmniAuth integration (Google, Facebook, Twitter, LinkedIn)
- ✅ Secure password requirements (minimum 12 characters)
- ✅ Email normalization (lowercase, trimmed)
- ✅ Session-based authentication with signed cookies

### CRUD Operations
- ✅ Users CRUD with GenericCrudInteractor
- ✅ Ransack search/filtering integration
- ✅ Pagy pagination (10 items per page default)
- ✅ Multi-format responses (HTML, JSON, Turbo Stream)
- ✅ SmartTableComponent for data tables

### UI/UX Components
- ✅ ViewComponents architecture
- ✅ Turbo Frame-based modals
- ✅ Turbo Stream updates for forms
- ✅ SmartTableComponent with search and sorting
- ✅ Dashboard layout components
- ✅ Responsive Tailwind CSS styling

### Admin Panel
- ✅ Avo admin interface at `/avo`
- ✅ Pundit authorization integration

### Progressive Web App (PWA)
- ✅ Web App Manifest (`/manifest.json`)
- ✅ Service Worker for offline support (`/service-worker.js`)
- ✅ Installable as standalone app
- ✅ Offline fallback page (`/offline.html`)
- ✅ App icons (192x192, 512x512, SVG)
- ✅ iOS Safari support (apple-touch-icon)
- ✅ Network-first caching strategy
- ✅ Automatic service worker updates
- ✅ Install prompt handling
- ✅ Online/offline status detection

### Testing Coverage
- ✅ 102 passing specs (0 failures, 14 pending)
- ✅ Model specs (User, Session)
- ✅ Request specs (Users, Sessions, Registrations, Passwords, Home, OmniAuth, PWA)
- ✅ PWA specs (31 tests for manifest, service worker, icons, meta tags)
- ✅ FactoryBot factories
- ✅ Shoulda matchers for validations
- ✅ OmniAuth test helpers

## Development Commands

### Setup and Running
- **Initial setup**: `bin/setup` (idempotent, run after pulling new dependencies)
- **Reset database**: `bin/setup --reset`
- **Start dev server**: `bin/dev` (runs Puma server + Tailwind watcher via Foreman)
- **App URL**: http://localhost:3000

### Testing and Linting
- **Run all checks**: `bin/rake` (runs RSpec + Rubocop)
- **Run checks in parallel**: `bin/rake -m` (faster but interleaved output)
- **Auto-fix lint issues**: `bin/rake fix`
- **Run specs**: `bin/rspec`
- **Run single spec**: `bin/rspec spec/path/to/spec.rb`
- **Run specific line**: `bin/rspec spec/path/to/spec.rb:LINE_NUMBER`

## Architecture Patterns

### Generic CRUD Pattern
The app uses a consistent pattern for CRUD operations through Interactors and service objects:

1. **GenericCrudInteractor** (`app/interactors/generic_crud_interactor.rb`):
   - Handles `:create`, `:read`, `:update`, `:delete`, `:fetch` actions
   - Integrates Ransack for search/filtering and Pagy for pagination
   - Supports caching with configurable cache keys and expiration
   - Format-aware (`:json`, `:turbo_stream`, `:html`)

2. **GenericCrudLoader** (`app/controllers/concerns/generic_crud_loader.rb`):
   - Controller concern providing `load_crud_records(model:, items:)` method
   - Automatically extracts Ransack params from `params[:q]`
   - Sets `@pagy`, `@records`, `@ransack` instance variables as helper methods

3. **Usage Pattern** (see `app/controllers/users_controller.rb`):
   ```ruby
   # In controller
   include GenericCrudLoader

   def index
     load_crud_records(model: User, items: 10)
     # @pagy, @records, @ransack now available
   end

   def create
     result = GenericCrudInteractor.call(
       model: User,
       action: :create,
       params: user_params
     )
     # result.success? / result.failure? / result.record / result.error
   end
   ```

### ViewComponents
- Uses ViewComponent gem for UI components (`app/components/`)
- **SmartTableComponent**: Reusable table with Ransack search, sorting, and Pagy pagination
  - Accepts: `columns:`, `records:`, `ransack:`, `pagy:`, `result_frame_id:`, `search_predicates:`
  - Integrates with Turbo Frames for SPA-like updates
- All components have corresponding specs in `spec/components/`

### Authentication & Authorization
- Uses authentication-zero pattern with custom implementation
- OmniAuth configured for: Google, Facebook, Twitter, LinkedIn
- Pundit for authorization (explicit authorization enabled)
- Avo admin panel at `/avo` (Community edition)
- Session-based auth with encrypted cookies

### Models & Validation
- Models use `has_secure_password` for authentication
- Models must define `ransackable_attributes` for Ransack search
- Use schema annotations via annotaterb gem
- Follow Rails 8 conventions (e.g., `generates_token_for` for email verification/password reset)

### Turbo & Hotwire Patterns
- Turbo Frames used extensively for partial page updates
- Modal pattern: Use turbo_stream to update "modal" frame
- List updates: Replace specific frames (e.g., "users_list") with new content
- Forms return turbo_stream responses for both success and validation errors

### Debugging
- `pry-remote` available in development/test
- `binding.remote_pry` can be used for remote debugging
- **WARNING**: Remove all `binding.remote_pry` calls before committing
- Bullet gem enabled to detect N+1 queries in development

## Testing Strategy

- RSpec for testing (not Minitest)
- FactoryBot for test data (factories in `spec/factories/`)
- Request specs for all controllers
- Model specs with Shoulda matchers
- OmniAuth testing with mock authentication
- Custom AuthHelpers for request specs (`spec/support/auth_helpers.rb`)
- Auto-loaded support files from `spec/support/`
- Current test status: **71 examples, 0 failures, 14 pending**

## Key Gems & Integrations

- **Ransack**: Advanced search/filtering (define `ransackable_attributes` on models)
- **Pagy**: Fast pagination (included in ApplicationController)
- **Interactor**: Service object pattern for business logic
- **ViewComponent**: Component-based views
- **Avo**: Admin panel (explicit authorization required)
- **Tailwind CSS**: Utility-first CSS (@tailwindcss/forms, @tailwindcss/typography)
- **Kamal**: Deployment orchestration
- **Solid Queue/Cache/Cable**: Rails 8 infrastructure

## Important Notes

- Always use `fix_ransack_params(params[:q])` before passing to Ransack to handle parameter sanitization
- Turbo Frame responses must specify the frame ID to update
- When using GenericCrudInteractor for fetch, results are cached for 5 minutes by default
- Models must explicitly define ransackable attributes for security
- Remove all `binding.remote_pry` debugging statements before committing
- Always using ruby 3.3.9 from mise

## Routes & Endpoints

### Authentication
- `GET /sign_up` - New user registration
- `POST /sign_up` - Create user account
- `GET /sign_in` - Sign in page
- `POST /sign_in` - Authenticate user
- `GET /sessions` - List active sessions
- `DELETE /sessions/:id` - Destroy session
- `GET /password/edit` - Change password form
- `PUT /password` - Update password

### OmniAuth
- `POST /auth/:provider/callback` - OAuth callback (Google, Facebook, Twitter, LinkedIn)
- `GET /auth/failure` - OAuth failure handler

### Users
- `GET /users` - List users (supports HTML, JSON, Turbo Stream)
- `GET /users/new` - New user form (Turbo Stream modal)
- `POST /users` - Create user
- `GET /users/:id/edit` - Edit user form
- `PATCH /users/:id` - Update user
- `DELETE /users/:id` - Destroy user

### Admin
- `/avo/*` - Avo admin panel (requires authentication & authorization)

## Development Workflow

1. **Creating a new CRUD resource:**
   - Generate model with `ransackable_attributes`
   - Use `GenericCrudInteractor` in controller
   - Include `GenericCrudLoader` concern
   - Use `SmartTableComponent` for index view
   - Write specs using FactoryBot factories

2. **Adding authentication to a controller:**
   - Inherit from `ApplicationController` (authentication enabled by default)
   - Use `skip_before_action :authenticate` for public actions
   - Current user available via `Current.user`
   - Current session available via `Current.session`

3. **Testing authenticated endpoints:**
   - Use `sign_in(user)` helper in request specs
   - Helper stubs authentication and sets `Current.session`
   - See `spec/support/auth_helpers.rb` for implementation

## Progressive Web App (PWA) Features

The application is fully PWA-enabled and can be installed on mobile devices and desktops.

### Key Files:
- **`/public/manifest.json`** - Web app manifest with app metadata
- **`/public/service-worker.js`** - Service worker for offline support and caching
- **`/app/javascript/pwa.js`** - PWA registration and install prompt handling
- **`/public/offline.html`** - Beautiful offline fallback page
- **`/public/icon-*.png`** - App icons in multiple sizes

### Features:
1. **Installable**: Users can install the app to their home screen
2. **Offline Support**: Service worker caches assets for offline use
3. **Network-First**: Always tries network first, falls back to cache
4. **Auto-Updates**: Service worker automatically updates when new version deployed
5. **Install Prompt**: Custom install button (add `id="install-button"` to any element)
6. **Status Detection**: Automatic online/offline status monitoring

### Testing PWA:
1. **Chrome DevTools**:
   - Open DevTools > Application > Manifest
   - Check "Service Workers" and "Cache Storage"
   - Click "Add to homescreen" to test installation

2. **Lighthouse**:
   - Run Lighthouse PWA audit in Chrome DevTools
   - Should score 100% on PWA requirements

3. **Mobile Testing**:
   - Deploy to production with HTTPS
   - Visit on mobile browser
   - Look for "Add to Home Screen" prompt

### Customization:
- Update app name and colors in `/public/manifest.json`
- Replace icons in `/public/` (see `ICON_INSTRUCTIONS.md`)
- Modify caching strategy in `/public/service-worker.js`
- Customize offline page in `/public/offline.html`