// Progressive Web App Service Worker Registration
// This file handles service worker registration and PWA installation

// Register service worker
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker
      .register('/service-worker.js')
      .then((registration) => {
        console.log('Service Worker registered:', registration.scope);

        // Check for updates periodically
        setInterval(() => {
          registration.update();
        }, 60000); // Check every minute

        // Handle service worker updates
        registration.addEventListener('updatefound', () => {
          const newWorker = registration.installing;

          newWorker.addEventListener('statechange', () => {
            if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
              // New service worker available, show update prompt
              if (confirm('New version available! Click OK to update.')) {
                newWorker.postMessage({ type: 'SKIP_WAITING' });
                window.location.reload();
              }
            }
          });
        });
      })
      .catch((error) => {
        console.error('Service Worker registration failed:', error);
      });

    // Handle service worker controller change
    navigator.serviceWorker.addEventListener('controllerchange', () => {
      window.location.reload();
    });
  });
}

// PWA Install Prompt
let deferredPrompt;

window.addEventListener('beforeinstallprompt', (e) => {
  // Prevent the mini-infobar from appearing on mobile
  e.preventDefault();

  // Stash the event so it can be triggered later
  deferredPrompt = e;

  // Show install button or banner
  showInstallPromotion();
});

function showInstallPromotion() {
  // Create install button if it doesn't exist
  const installButton = document.getElementById('install-button');

  if (installButton) {
    installButton.style.display = 'block';

    installButton.addEventListener('click', async () => {
      if (deferredPrompt) {
        // Show the install prompt
        deferredPrompt.prompt();

        // Wait for the user to respond to the prompt
        const { outcome } = await deferredPrompt.userChoice;

        console.log(`User response to the install prompt: ${outcome}`);

        // Clear the deferredPrompt
        deferredPrompt = null;

        // Hide the install button
        installButton.style.display = 'none';
      }
    });
  }
}

// Track installation
window.addEventListener('appinstalled', () => {
  console.log('PWA was installed');

  // Hide install button
  const installButton = document.getElementById('install-button');
  if (installButton) {
    installButton.style.display = 'none';
  }

  // Optional: Track installation analytics
  // analytics.logEvent('pwa_installed');
});

// Detect if app is running in standalone mode (installed PWA)
window.addEventListener('load', () => {
  if (window.matchMedia('(display-mode: standalone)').matches) {
    console.log('Running as installed PWA');
    document.body.classList.add('pwa-installed');
  }
});

// Handle offline/online status
window.addEventListener('online', () => {
  console.log('Back online');
  document.body.classList.remove('offline');
  document.body.classList.add('online');

  // Optional: Show toast notification
  showToast('You are back online', 'success');
});

window.addEventListener('offline', () => {
  console.log('Offline');
  document.body.classList.add('offline');
  document.body.classList.remove('online');

  // Optional: Show toast notification
  showToast('You are offline. Some features may be limited.', 'warning');
});

// Helper function to show toast (optional - implement based on your UI)
function showToast(message, type = 'info') {
  // Implement your toast notification here
  console.log(`[${type.toUpperCase()}] ${message}`);
}

// Optional: Add to home screen detection for iOS
function isIOS() {
  return /iPhone|iPad|iPod/.test(navigator.userAgent) && !window.MSStream;
}

function isInStandaloneMode() {
  return ('standalone' in window.navigator) && window.navigator.standalone;
}

if (isIOS() && !isInStandaloneMode()) {
  // Show iOS install instructions
  console.log('iOS user - show "Add to Home Screen" instructions');
  // You can show a custom banner with instructions for iOS users
}
