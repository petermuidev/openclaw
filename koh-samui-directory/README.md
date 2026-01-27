# 🏝️ Koh Samui Travel Directory

A statically generated Next.js directory website showcasing tours and activities from real owners in Koh Samui, Thailand.

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Automation Workflow](#automation-workflow)
- [Data Model](#data-model)
- [Development](#development)
- [Deployment](#deployment)
- [Contributing](#contributing)

---

## Project Overview

This project aims to create a curated directory of tours, activities, and services in Koh Samui where:

- **Travelers** can discover authentic experiences directly from operators
- **Local businesses** can showcase their offerings without commission fees
- **Information** is accurate, verified, and kept up-to-date

### Key Metrics

| Metric | Target |
|--------|--------|
| Listings | 100+ verified |
| Categories | 8 main categories |
| Areas | 10 beach/area pages |
| SEO Keywords | Top 3 rankings |

---

## Features

### Core Features (P0)

- ✅ Search & Filter (category, area, price, rating)
- ✅ Listing Detail pages with full tour info
- ✅ Category & Area pages
- ✅ Direct Contact buttons (phone, LINE, WhatsApp)
- ✅ Static Export for fast performance
- ✅ SEO Optimization

### Secondary Features (P1)

- 🗺️ Interactive Map View
- 🏷️ Owner Verification badges
- 🔗 Related listings
- 📤 Social sharing

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Next.js 14 (App Router), TypeScript, Tailwind CSS |
| Data | JSON files, Zod validation |
| Automation | Clawdbot (Perplexity Search + Browser Crawl) |
| Deployment | Vercel (Static Export) |
| Domain | kohsamui-directory.com |

---

## Project Structure

```
kohsamui-directory/
├── data/                          # Data layer
│   ├── listings.json              # Main listing data (auto-generated)
│   ├── operators.json             # Operators during research
│   ├── categories.json            # Category definitions
│   ├── areas.json                 # Area definitions
│   └── directory-config.json      # Project configuration
│
├── scripts/                       # Automation scripts
│   ├── research.js                # Research workflow
│   ├── crawl.js                   # Website crawling
│   ├── process.js                 # Data processing
│   └── validate.js                # Schema validation
│
├── src/                           # Next.js application
│   ├── app/                       # App Router pages
│   │   ├── page.tsx               # Homepage
│   │   ├── layout.tsx             # Root layout
│   │   ├── search/
│   │   ├── category/
│   │   ├── area/
│   │   └── listing/
│   │
│   ├── components/                # React components
│   │   ├── ListingCard.tsx
│   │   ├── SearchFilters.tsx
│   │   ├── ContactButtons.tsx
│   │   └── MapView.tsx
│   │
│   └── lib/                       # Utilities
│       ├── listings.ts
│       ├── search.ts
│       ├── types.ts
│       └── schema.ts
│
├── public/                        # Static assets
│   ├── images/
│   └── robots.txt
│
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
├── package.json
└── README.md
```

---

## Getting Started

### Prerequisites

- Node.js 18+
- npm or yarn
- Clawdbot (for automation)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/kohsamui-directory.git
cd kohsamui-directory

# Install dependencies
npm install

# Install Clawdbot (if not already installed)
npm install -g clawdbot

# Set up Clawdbot
clawdbot gateway start
```

### Development

```bash
# Start development server
npm run dev

# Build for production
npm run build

# Export static site
npm run export

# Validate data
npm run validate
```

---

## Automation Workflow

### Phase 1: Research

```bash
# Research operators for each category
node scripts/research.js
```

This will:
1. Search for operators using Clawdbot + Perplexity
2. Collect URLs from search results
3. Save to `data/operators.json`

### Phase 2: Crawl

```bash
# Crawl operator websites for details
node scripts/crawl.js
```

This will:
1. Visit each operator website
2. Extract tour details, pricing, contact info
3. Update operator records

### Phase 3: Process

```bash
# Transform and validate data
node scripts/process.js
```

This will:
1. Transform operators to listings
2. Validate against schema
3. Generate `data/listings.json`

### Phase 4: Build

```bash
# Build Next.js static site
npm run build
npm run export
```

---

## Data Model

### Listing Schema

```json
{
  "id": "001",
  "slug": "coral-dive-center-chaweng",
  "name": "Coral Dive Center",
  "category": "diving-snorkeling",
  "description": "Professional PADI dive center...",
  "location": {
    "area": "chaweng",
    "address": "123 Chaweng Beach Road",
    "coordinates": { "lat": 9.5332, "lng": 100.0665 }
  },
  "itinerary": {
    "duration": "Full Day",
    "highlights": ["Reef diving", "Lunch included"],
    "schedule": "8:00 AM - 4:00 PM",
    "inclusions": ["Equipment", "Insurance"],
    "exclusions": ["Personal expenses"]
  },
  "pricing": {
    "adult": 3500,
    "currency": "THB",
    "discount_available": true
  },
  "owner": {
    "name": "Somsak Chaiyasit",
    "verified": true
  },
  "contact": {
    "phone": "+66 77 123 456",
    "line_id": "coraldivethailand",
    "website": "https://example.com"
  },
  "status": "published"
}
```

### Categories

| ID | Name | Icon |
|----|------|------|
| diving-snorkeling | Diving & Snorkeling | 🤿 |
| island-hopping | Island Hopping | 🚤 |
| adventure | Adventure & Wildlife | 🏕️ |
| wellness-spa | Wellness & Spa | 🧘 |
| food-tours | Food & Culture | 🍜 |
| transport | Transportation | 🚗 |
| accommodation | Accommodation | 🏨 |
| nightlife | Nightlife | 🌙 |

### Areas

| ID | Name | Coordinates |
|----|------|-------------|
| chaweng | Chaweng | 9.5332, 100.0665 |
| lamai | Lamai | 9.4599, 100.0535 |
| bophut | Bophut | 9.5604, 100.0334 |
| maenam | Maenam | 9.5718, 100.0426 |
| choeng-mon | Choeng Mon | 9.5514, 100.0816 |

---

## Development

### Adding New Categories

1. Update `data/categories.json`
2. Add to TypeScript types in `src/lib/types.ts`
3. Create category page in `src/app/category/[slug]/`
4. Update search filters in `src/components/SearchFilters.tsx`

### Adding New Listings

**Option 1: Manual**
1. Add to `data/listings.json`
2. Run `npm run validate`
3. Rebuild

**Option 2: Automated**
1. Run `node scripts/research.js`
2. Run `node scripts/crawl.js`
3. Run `node scripts/process.js`

### Testing

```bash
# Run unit tests
npm run test

# Run e2e tests
npm run test:e2e

# Type checking
npm run typecheck

# Linting
npm run lint
```

---

## Deployment

### Vercel (Recommended)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel --prod
```

### GitHub Actions

The project includes `.github/workflows/deploy.yml` for automatic deployment on push to main.

### Environment Variables

```env
# No sensitive env vars needed for static export
# All data is in JSON files
```

---

## Pricing Reference (Market Research)

| Category | Min (THB) | Max (THB) |
|----------|-----------|-----------|
| Snorkeling Trip | 800 | 2,000 |
| Fun Dive | 2,500 | 4,000 |
| Open Water Course | 12,000 | 15,000 |
| Island Hopping | 1,500 | 3,500 |
| ATV Adventure | 1,500 | 3,000 |
| Elephant Sanctuary | 2,000 | 5,000 |
| Cooking Class | 1,200 | 2,500 |
| Thai Massage | 500 | 800 |
| Airport Transfer | 500 | 1,500 |

---

## SEO Strategy

### Target Keywords

| Priority | Keyword |
|----------|---------|
| P0 | things to do in Koh Samui |
| P0 | Koh Samui tours |
| P0 | best tours Koh Samui |
| P1 | Koh Samui activities |
| P1 | Koh Samui diving |

### SEO Features

- ✅ Meta tags per page
- ✅ Schema.org markup (LocalBusiness, Product)
- ✅ Sitemap.xml auto-generation
- ✅ Canonical URLs
- ✅ Open Graph tags
- ✅ Twitter Card tags

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting
5. Submit a pull request

---

## License

MIT License - feel free to use this for your own projects.

---

## Acknowledgments

- [Clawdbot](https://clawd.bot/) - AI automation platform
- [Next.js](https://nextjs.org/) - React framework
- [Tailwind CSS](https://tailwindcss.com/) - Styling
- [Perplexity](https://perplexity.ai/) - Web search

---

**Built with ❤️ using Clawdbot AI Assistant**  
*January 2026*
