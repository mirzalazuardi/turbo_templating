# Progressive Web App (PWA) Setup

Your Rails application is now fully PWA-enabled! 🎉

## What's Been Added

### Core PWA Files
- ✅ **`/public/manifest.json`** - Web app manifest defining app metadata
- ✅ **`/public/service-worker.js`** - Service worker for offline functionality
- ✅ **`/app/javascript/pwa.js`** - PWA registration and install prompt handling
- ✅ **`/public/offline.html`** - Beautiful offline fallback page
- ✅ **App icons** - Multiple sizes for different devices

### Application Updates
- ✅ Enhanced `<head>` meta tags in `app/views/layouts/application.html.erb`
- ✅ PWA JavaScript imported in `app/javascript/application.js`
- ✅ Service worker registered automatically on page load

## Features

### 📱 Installable
Users can install your app to their home screen on mobile and desktop devices.

### 🔌 Offline Support
The service worker caches assets and provides offline functionality:
- Network-first strategy: tries network, falls back to cache
- Beautiful offline page when completely offline
- Automatic cache updates

### 🔄 Auto-Updates
Service worker automatically updates when you deploy new versions.

### 📊 Status Monitoring
- Detects online/offline status
- Shows appropriate UI feedback
- Auto-reconnects when back online

## Testing Your PWA

### 1. Local Testing (Chrome)
```bash
# Make sure your app is running
bin/dev

# Open in Chrome
open http://localhost:3000
```

Then in Chrome:
1. Open DevTools (F12)
2. Go to **Application** tab
3. Check **Manifest** - should show your app details
4. Check **Service Workers** - should show registered worker
5. Check **Cache Storage** - will populate as you browse

### 2. Test Installation
In Chrome address bar, look for the install icon (⊕) or:
1. Click the menu (⋮)
2. Select "Install Turbo Templating..."
3. Confirm installation
4. App opens in standalone window!

### 3. Test Offline Mode
1. Open DevTools
2. Go to **Network** tab
3. Check "Offline" checkbox
4. Reload page
5. Should see cached version or offline page

### 4. Lighthouse Audit
1. Open DevTools
2. Go to **Lighthouse** tab
3. Select **Progressive Web App**
4. Click **Analyze page load**
5. Should score high on PWA requirements

## Production Deployment

### Requirements
- ✅ HTTPS (required for service workers)
- ✅ Valid SSL certificate
- ✅ Proper server headers

### Deployment Checklist
1. **Deploy to production** (must have HTTPS)
2. **Test on mobile device**:
   - Visit your site on iOS Safari or Chrome
   - Look for "Add to Home Screen" prompt
   - Install and test

3. **Verify PWA criteria**:
   ```bash
   # Run Lighthouse in production
   lighthouse https://your-domain.com --view
   ```

## Customization

### Update App Name and Colors
Edit `/public/manifest.json`:
```json
{
  "name": "Your App Name",
  "short_name": "YourApp",
  "theme_color": "#your-color",
  "background_color": "#your-color"
}
```

### Replace Icons
1. Create PNG images:
   - 192x192 pixels → `icon-192.png`
   - 512x512 pixels → `icon-512.png`

2. Use a tool like [PWA Builder](https://www.pwabuilder.com/imageGenerator)

3. Replace files in `/public/`

See `/public/ICON_INSTRUCTIONS.md` for detailed instructions.

### Customize Offline Page
Edit `/public/offline.html` to match your branding.

### Modify Caching Strategy
Edit `/public/service-worker.js`:
- Change `CACHE_VERSION` when you want to force cache updates
- Modify `PRECACHE_URLS` to cache specific assets
- Adjust caching logic in the `fetch` event listener

## Adding Install Button

Add a button to your UI with `id="install-button"`:

```erb
<button id="install-button" style="display: none;">
  📱 Install App
</button>
```

The PWA JavaScript automatically:
- Shows button when installation is available
- Handles the install prompt
- Hides button after installation

## Troubleshooting

### Service Worker Not Registering
- Check browser console for errors
- Ensure you're on `localhost` or HTTPS
- Clear browser cache and reload

### Icons Not Showing
- Check icon files exist in `/public/`
- Verify paths in `manifest.json`
- Clear browser cache

### Install Prompt Not Showing
- Must be on HTTPS (or localhost)
- User must visit site at least twice
- Can't show if already installed
- Check Chrome's install criteria in DevTools

### Cache Not Updating
- Increment `CACHE_VERSION` in service-worker.js
- Force refresh (Cmd+Shift+R / Ctrl+Shift+R)
- Clear cache in DevTools > Application > Clear storage

## Browser Support

| Feature | Chrome | Firefox | Safari | Edge |
|---------|--------|---------|--------|------|
| Service Worker | ✅ | ✅ | ✅ | ✅ |
| Web Manifest | ✅ | ✅ | ✅ | ✅ |
| Install Prompt | ✅ | ❌ | ✅* | ✅ |
| Push Notifications | ✅ | ✅ | ❌ | ✅ |

*iOS Safari uses "Add to Home Screen" in share menu

## Next Steps

1. ✅ Test installation on your device
2. ✅ Customize icons and colors
3. ✅ Run Lighthouse audit
4. ✅ Deploy to production with HTTPS
5. ✅ Test on various devices
6. Consider adding:
   - Push notifications
   - Background sync
   - Periodic background sync
   - Web Share API

## Resources

- [PWA Builder](https://www.pwabuilder.com/)
- [MDN PWA Guide](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps)
- [Google PWA Checklist](https://web.dev/pwa-checklist/)
- [Service Worker Cookbook](https://serviceworke.rs/)

Enjoy your Progressive Web App! 🚀
