# Mohács 500 – A Közös Jövő Mozgalom

**A múlt sebeiből kiindulva a jövő felelősségére hív minden magyar testvért és keresztény lelki életet.**

## 🎯 Project Overview

Mohács 500 is a multilingual (Hungarian/English) movement website dedicated to commemorating the 500th anniversary of the Battle of Mohács (1526) and calling for spiritual renewal, national unity, and collective responsibility across all Christian denominations. The site coordinates two major gatherings in 2026:

- **April 4, 2026** – Spiritual unity gathering (Easter Saturday)
- **August 29, 2026** – Second gathering for freedom and spiritual renewal

The movement transcends sectarian and organizational boundaries, focusing on prayer and community building among Hungarian speakers and Christian communities worldwide.

## 🎨 Color Palette

The site uses a carefully curated color palette that reflects the movement's spiritual and optimistic nature:

### Primary Colors

| Color | Hex Code | Name | Purpose |
|-------|----------|------|---------|
| ![#472d30](https://via.placeholder.com/20/472d30/472d30?text=+) | `#472d30` | **Mauve Shadow** | Primary text, dark accents, sophisticated foundation |
| ![#c9cba3](https://via.placeholder.com/20/c9cba3/c9cba3?text=+) | `#c9cba3` | **Dry Sage** | Secondary accents, borders, earthy tones |
| ![#e26d5c](https://via.placeholder.com/20/e26d5c/e26d5c?text=+) | `#e26d5c` | **Vibrant Coral** | Tertiary accents, warmth, emphasis elements |
| ![#ffe1a8](https://via.placeholder.com/20/ffe1a8/ffe1a8?text=+) | `#ffe1a8` | **Soft Peach** | Highlights, delicate accents, light emphasis |
| ![#723d46](https://via.placeholder.com/20/723d46/723d46?text=+) | `#723d46` | **Wine Plum** | Supporting text, secondary accents, depth |

### Color Philosophy

- **Mauve Shadow** – Lush drama and mysterious elegance, evoking contemplation and spiritual depth
- **Dry Sage** – Gentle, earthy whispers that calm and blend resilience with sunlight
- **Vibrant Coral** – Vivid, sun-warmed energy infusing warmth, optimism, and playful spirit
- **Soft Peach** – Delicate, pastel warmth enveloping like spring blooms
- **Wine Plum** – Rich, captivating nocturnal secrets supporting introspective journeys

## 🛠️ Technical Stack

- **Static Site Generator:** [Hugo](https://gohugo.io) v0.120+
- **Theme:** Fortify Hugo (custom-built security/SaaS template)
- **CSS Framework:** Tailwind CSS 4.1+
- **Styling:** Custom CSS with Hugo theme system
- **Build Tools:** Node.js, Yarn
- **Hosting Platforms:** Netlify, Vercel, Cloudflare Pages (via Wrangler)

## 📦 Project Structure

```
.
├── assets/                 # CSS, images, and static assets
│   ├── css/
│   │   └── custom.css     # Custom color palette and component styling
│   └── images/            # Optimized images by section
├── config/                # Hugo configuration
│   ├── _default/          # Default settings
│   │   ├── languages.toml # Language configuration (HU/EN)
│   │   ├── menus.*.toml   # Navigation menus (Hungarian/English)
│   │   ├── module.toml    # Module mounts
│   │   └── params.toml    # Theme parameters
│   └── development/       # Development-specific overrides
├── content/               # Page content
│   └── english/           # Primary language content structure
│       ├── about/         # About section
│       ├── blog/          # Blog posts
│       ├── changelog/     # Version history and updates
│       ├── contact/       # Contact page
│       ├── feature/       # Feature descriptions
│       ├── integration/   # Integration information
│       ├── pricing/       # Membership/participation tiers
│       ├── review/        # Testimonials and reviews
│       └── sections/      # Page sections
├── data/                  # Data files
│   ├── theme.json         # Color palette definitions
│   └── social.json        # Social media links
├── public/                # Built static site (generated)
├── themes/                # Hugo theme (Fortify)
├── i18n/                  # Internationalization files
├── hugo.toml              # Hugo main configuration
├── netlify.toml           # Netlify deployment config
├── vercel.json            # Vercel deployment config
├── wrangler.jsonc         # Cloudflare Workers config
├── package.json           # Node.js dependencies
└── tailwind.config.js     # Tailwind CSS configuration
```

## 🚀 Getting Started

### Prerequisites

- Hugo 0.120+ ([Download](https://gohugo.io/installation/))
- Node.js 18+ and Yarn/npm ([Download](https://nodejs.org/))

### Installation & Development

1. **Install dependencies:**
   ```bash
   yarn install
   ```

2. **Run local development server:**
   ```bash
   yarn dev
   ```
   The site will be available at `http://localhost:1313`

3. **Build for production:**
   ```bash
   yarn build
   ```

4. **Preview production build:**
   ```bash
   yarn preview
   ```

### Example Site Development

If you're developing the theme alongside the main site:

```bash
yarn dev:example      # Run example site locally
yarn build:example    # Build example site
```

## 🎨 Customizing Colors

The color palette is defined in two locations:

### 1. **Data Configuration** (`data/theme.json`)
Controls the base color scheme used throughout the site:
```json
{
  "colors": {
    "default": {
      "theme_color": {
        "primary": "#472d30",      // Mauve Shadow
        "secondary": "#c9cba3",    // Dry Sage
        "tertiary": "#e26d5c",     // Vibrant Coral
        "quaternary": "#ffe1a8",   // Soft Peach
        "dark": "#472d30"
      }
    }
  }
}
```

### 2. **Custom Styles** (`assets/css/custom.css`)
Applies color-specific styling to components like:
- Countdown cards (gradient backgrounds)
- Text colors and labels
- Accent decoration elements
- Hover and active states

## 📱 Responsive Design

The site is fully responsive and tested on:
- Desktop (1024px+)
- Tablet (768px - 1023px)
- Mobile (< 768px)

Key breakpoints are managed through Tailwind CSS utility classes.

## 🌍 Internationalization

The site supports multiple languages:
- **Hungarian** (HU) – Default/Primary
- **English** (EN) – Translation available

Language configuration is managed through:
- `config/_default/languages.toml` – Language settings
- `config/_default/menus.en.toml` & `menus.hu.toml` – Navigation menus per language
- `i18n/en.yaml` – Translated UI strings

## 🔄 Deployment

### Netlify
```bash
yarn build
# Deploy the `public/` directory
```
Configuration: `netlify.toml`

### Vercel
```bash
yarn build
# Deploy the `public/` directory
```
Configuration: `vercel.json` + `vercel-build.sh`

### Cloudflare Pages
Via Wrangler CLI and `wrangler.jsonc` configuration.

## 📝 Content Management

Content is organized by language and section:
- Each major section (blog, pricing, features) has its own folder
- Content files use Markdown (.md) with YAML frontmatter
- Featured images and galleries are located in `assets/images/`

### Adding a New Blog Post
1. Create a new file: `content/english/blog/post-title.md`
2. Add frontmatter (title, date, description, image)
3. Write content in Markdown
4. The file will appear in blog listings automatically

## 🔗 Key URLs

- **Main Site:** `/`
- **About/Vision:** `/latas`
- **April 4 Event:** `/aprilis-4`
- **Blog:** `/blog`
- **Features:** `/feature`
- **Pricing/Participation:** `/pricing`
- **Contact:** `/contact`

## 📊 Performance & Analytics

- Google Analytics ready (configure ID in `hugo.toml`)
- Optimized images with WebP support
- Code minification enabled in production builds
- Critical CSS and lazy-loaded resources

## 🔧 Maintenance

### Update Hugo Modules
```bash
yarn update-modules
```

### Format Code
```bash
yarn format
```
Uses Prettier with Hugo template and Tailwind CSS plugins.

### Project Setup Scripts
```bash
yarn project-setup    # Initialize project
yarn theme-setup      # Setup theme components
```

## 📧 Contact & Support

For questions about the Mohács 500 movement, visit the [contact page](/contact).

## 📄 License

UNLICENSED – This is a proprietary project.

---

**Mohács 500 – Közös emlékezetből közös jövő**  
*From shared memory, a shared future*
