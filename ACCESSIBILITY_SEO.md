# Accessibility & SEO Guide

## Overview

This application is built with comprehensive accessibility (a11y) and search engine optimization (SEO) features to ensure an inclusive and discoverable experience for all users.

## Accessibility Features

### WCAG 2.1 Level AA Compliance

This application implements the following accessibility standards:

#### 1. **Semantic HTML**
- Proper use of `<nav>`, `<main>`, `<header>`, `<footer>` elements
- Correct heading hierarchy (h1-h6)
- Semantic table structure with `<thead>`, `<tbody>`, `<th scope="col">`

#### 2. **ARIA Labels and Roles**
- Navigation regions labeled: `aria-label="Main Sidebar Navigation"`
- Primary and secondary navigation clearly distinguished
- Form fields with proper `aria-required`, `aria-invalid`, `aria-describedby`
- Live regions for dynamic content: `aria-live="polite"`
- Table roles: `role="table"`, `role="row"`, `role="cell"`, `role="columnheader"`

#### 3. **Keyboard Navigation**
- **Skip to main content** link: Press Tab on page load to bypass navigation
- All interactive elements are keyboard accessible
- Visible focus indicators on all focusable elements
- Logical tab order throughout the application

#### 4. **Screen Reader Support**
- Hidden labels with `sr-only` class for screen readers
- Icons marked with `aria-hidden="true"` to avoid confusion
- Form errors announced with `role="alert"` and `aria-live="polite"`
- Current page indicated with `aria-current="page"`

#### 5. **Form Accessibility**
- All inputs have associated `<label>` elements
- Required fields marked with `aria-required="true"`
- Error messages linked to inputs via `aria-describedby`
- Invalid fields marked with `aria-invalid="true"`
- Error summaries with proper heading structure

#### 6. **Color Contrast**
- Text meets WCAG AA contrast ratios (4.5:1 for normal text)
- Interactive elements have clear visual states
- Error states use both color and text/icons

### Testing Your Accessibility

#### Automated Tools

1. **Lighthouse (Chrome DevTools)**
   ```bash
   # Open DevTools (F12)
   # Go to Lighthouse tab
   # Select "Accessibility" category
   # Run audit
   ```

2. **axe DevTools (Browser Extension)**
   - Install: [axe DevTools for Chrome](https://chrome.google.com/webstore/detail/axe-devtools-web-accessib/lhdoppojpmngadmnindnejefpokejbdd)
   - Open extension and run scan

3. **WAVE (Web Accessibility Evaluation Tool)**
   - Visit: https://wave.webaim.org/
   - Enter your URL and analyze

#### Manual Testing

1. **Keyboard Navigation**
   ```
   Tab       - Move forward through interactive elements
   Shift+Tab - Move backward
   Enter     - Activate buttons/links
   Space     - Toggle checkboxes, activate buttons
   Arrows    - Navigate within components (if applicable)
   ```

2. **Screen Reader Testing**
   - **macOS**: VoiceOver (Cmd + F5)
   - **Windows**: NVDA (free) or JAWS
   - **Linux**: Orca

3. **Visual Testing**
   - Zoom to 200%: Content should remain readable
   - High contrast mode: Check Windows high contrast
   - Color blindness simulation: Use browser extensions

## SEO Features

### Meta Tags

The application includes comprehensive SEO meta tags:

#### Basic SEO
```erb
<title>Turbo Templating - Rails 8 PWA with Hotwire</title>
<meta name="description" content="...">
<meta name="keywords" content="...">
<meta name="author" content="...">
<meta name="robots" content="index, follow">
<link rel="canonical" href="...">
```

#### Open Graph (Facebook/LinkedIn)
```erb
<meta property="og:type" content="website">
<meta property="og:url" content="...">
<meta property="og:title" content="...">
<meta property="og:description" content="...">
<meta property="og:image" content="...">
<meta property="og:locale" content="en_US">
<meta property="og:site_name" content="...">
```

#### Twitter Card
```erb
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:url" content="...">
<meta name="twitter:title" content="...">
<meta name="twitter:description" content="...">
<meta name="twitter:image" content="...">
```

### Structured Data (JSON-LD)

The application uses Schema.org structured data:

```json
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Turbo Templating",
  "url": "...",
  "description": "...",
  "applicationCategory": "BusinessApplication",
  "operatingSystem": "Any",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  }
}
```

### Per-Page SEO Customization

You can customize SEO tags for each page:

```erb
<%# In your view file %>
<% content_for :title, "Custom Page Title" %>
<% content_for :description, "Custom page description for SEO" %>
<% content_for :keywords, "custom, keywords, here" %>
<% content_for :og_image, "https://example.com/custom-image.png" %>
```

### SEO Testing Tools

1. **Google Search Console**
   - Submit sitemap
   - Monitor crawl errors
   - Check mobile usability

2. **Google Rich Results Test**
   - Test structured data: https://search.google.com/test/rich-results

3. **Facebook Sharing Debugger**
   - Test Open Graph tags: https://developers.facebook.com/tools/debug/

4. **Twitter Card Validator**
   - Test Twitter Cards: https://cards-dev.twitter.com/validator

5. **Lighthouse SEO Audit**
   ```bash
   # In Chrome DevTools
   # Lighthouse tab > SEO category
   # Run audit
   ```

## Best Practices

### For Developers

1. **Always include alt text for images**
   ```erb
   <%= image_tag "logo.png", alt: "Company Logo" %>
   ```

2. **Use semantic HTML over divs**
   ```erb
   <%# Good %>
   <nav aria-label="Main navigation">

   <%# Avoid %>
   <div class="nav">
   ```

3. **Provide labels for all form inputs**
   ```erb
   <%= f.label :email, "Email address" %>
   <%= f.email_field :email, "aria-required": "true" %>
   ```

4. **Test with keyboard only**
   - Disconnect your mouse
   - Navigate the entire application with keyboard

5. **Write meaningful link text**
   ```erb
   <%# Good %>
   <%= link_to "Read our privacy policy", privacy_path %>

   <%# Avoid %>
   <%= link_to "Click here", privacy_path %>
   ```

6. **Ensure sufficient color contrast**
   - Use WebAIM Contrast Checker: https://webaim.org/resources/contrastchecker/

7. **Make dynamic content accessible**
   ```erb
   <div aria-live="polite" aria-atomic="true">
     <%= flash[:notice] %>
   </div>
   ```

### For Content Editors

1. **Use descriptive headings**
   - Headings should describe the content that follows
   - Don't skip heading levels (h1 → h3)

2. **Write in plain language**
   - Aim for 8th grade reading level
   - Use short sentences and paragraphs

3. **Provide transcripts for audio/video**
   - Include captions for videos
   - Provide text alternatives

4. **Make links descriptive**
   - Link text should make sense out of context
   - Avoid generic "click here" or "read more"

## Performance & Accessibility

Fast loading times benefit everyone, especially users with:
- Slow connections
- Older devices
- Cognitive disabilities

Our PWA features help:
- Service worker caching for offline access
- Optimized asset loading
- Progressive enhancement

## Resources

### Accessibility
- [WebAIM](https://webaim.org/)
- [A11Y Project](https://www.a11yproject.com/)
- [MDN Accessibility Guide](https://developer.mozilla.org/en-US/docs/Web/Accessibility)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

### SEO
- [Google Search Central](https://developers.google.com/search)
- [Moz SEO Learning Center](https://moz.com/learn/seo)
- [Schema.org](https://schema.org/)

### Testing
- [axe Accessibility Checker](https://www.deque.com/axe/)
- [WAVE Browser Extension](https://wave.webaim.org/extension/)
- [Lighthouse](https://developers.google.com/web/tools/lighthouse)

## Reporting Issues

If you discover accessibility issues:

1. Check if it's already fixed in the latest version
2. Create an issue with:
   - Steps to reproduce
   - Expected vs actual behavior
   - Assistive technology used (if applicable)
   - Screenshots/recordings

We're committed to maintaining WCAG 2.1 Level AA compliance and welcome feedback!
