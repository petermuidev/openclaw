# Koh Samui Travel Directory
## Product Requirements Document (PRD)

**Version:** 1.0  
**Date:** January 27, 2026  
**Author:** Clawdbot AI Assistant

---

## 1. Executive Summary

Build a static directory website showcasing tours and activities in Koh Samui, Thailand. All listings will be from real business owners, providing authentic experiences for travelers. The site will be statically generated using Next.js with all data stored in JSON files, researched and populated using Clawdbot automation.

---

## 2. Project Overview

### 2.1 Purpose
Create a curated directory of tours, activities, and services in Koh Samui where:
- **Travelers** can discover authentic experiences directly from operators
- **Local businesses** can showcase their offerings without commission fees
- **Information** is accurate, verified, and kept up-to-date

### 2.2 Target Audience
| User Type | Needs |
|-----------|-------|
| Travelers | Reliable tour info, direct contact, honest reviews |
| Tour Operators | Free listing, direct customer access, verification badge |
| Digital Nomads | Activity discovery, community recommendations |

### 2.3 Success Metrics
- 100+ verified listings by launch
- SEO ranking for "Koh Samui tours", "things to do in Koh Samui"
- Direct booking inquiries to operators
- Zero commission model sustainability

---

## 3. Data Model

### 3.1 Listing Schema (JSON)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "listings": {
      "type": "array",
      "items": { "$ref": "#/definitions/listing" }
    },
    "metadata": {
      "type": "object",
      "properties": {
        "total": { "type": "number" },
        "last_updated": { "type": "string" },
        "version": { "type": "string" }
      }
    }
  },
  "definitions": {
    "listing": {
      "type": "object",
      "required": ["id", "name", "category", "location", "owner", "contact"],
      "properties": {
        "id": { "type": "string", "description": "Unique identifier" },
        "slug": { "type": "string", "description": "URL-friendly name" },
        "name": { "type": "string", "description": "Business/Tour name" },
        "category": { "type": "string", "enum": ["diving-snorkeling", "island-hopping", "adventure", "wellness-spa", "food-tours", "transport", "accommodation", "nightlife"] },
        "description": { "type": "string", "description": "Full description" },
        "short_description": { "type": "string", "description": "For card display" },
        "location": {
          "type": "object",
          "properties": {
            "area": { "type": "string", "enum": ["chaweng", "lamai", "bophut", "maenam", "choeng-mon", "big-buddha", "taling-ngam", "nathon", "lipa-noi", "bang-por"] },
            "address": { "type": "string" },
            "coordinates": { "type": "object", "properties": { "lat": { "type": "number" }, "lng": { "type": "number" } } },
            "meeting_point": { "type": "string" }
          }
        },
        "itinerary": {
          "type": "object",
          "properties": {
            "duration": { "type": "string", "description": "e.g., '4 hours', 'Full day'" },
            "highlights": { "type": "array", "items": { "type": "string" } },
            "schedule": { "type": "string", "description": "e.g., 'Pickup 8:00 AM, Return 4:00 PM'" },
            "start_times": { "type": "array", "items": { "type": "string" } },
            "days_operated": { "type": "array", "items": { "type": "string" } },
            "inclusions": { "type": "array", "items": { "type": "string" } },
            "exclusions": { "type": "array", "items": { "type": "string" } },
            "what_to_bring": { "type": "array", "items": { "type": "string" } },
            "age_requirements": { "type": "string" },
            "fitness_level": { "type": "string", "enum": ["easy", "moderate", "challenging"] }
          }
        },
        "pricing": {
          "type": "object",
          "properties": {
            "adult": { "type": "number" },
            "child": { "type": "number" },
            "infant": { "type": "number" },
            "private_group": { "type": "number" },
            "currency": { "type": "string", "default": "THB" },
            "discount_available": { "type": "boolean" },
            "discount_percentage": { "type": "number" },
            "booking_required": { "type": "boolean" },
            "minimum_notice_hours": { "type": "number" }
          }
        },
        "owner": {
          "type": "object",
          "required": ["name"],
          "properties": {
            "name": { "type": "string" },
            "company": { "type": "string" },
            "license_number": { "type": "string" },
            "verified": { "type": "boolean", "default": false },
            "verified_date": { "type": "string" },
            "years_in_business": { "type": "number" }
          }
        },
        "contact": {
          "type": "object",
          "required": ["phone"],
          "properties": {
            "phone": { "type": "string" },
            "email": { "type": "string" },
            "website": { "type": "string" },
            "line_id": { "type": "string" },
            "facebook": { "type": "string" },
            "instagram": { "type": "string" },
            "whatsapp": { "type": "string" },
            "booking_url": { "type": "string" }
          }
        },
        "media": {
          "type": "object",
          "properties": {
            "hero_image": { "type": "string" },
            "gallery": { "type": "array", "items": { "type": "string" } },
            "video_url": { "type": "string" },
            "360_tour_url": { "type": "string" }
          }
        },
        "reviews": {
          "type": "object",
          "properties": {
            "rating": { "type": "number", "minimum": 0, "maximum": 5 },
            "count": { "type": "number" },
            "google_rating": { "type": "number" },
            "tripadvisor_rating": { "type": "number" }
          }
        },
        "tags": { "type": "array", "items": { "type": "string" } },
        "highlights": { "type": "array", "items": { "type": "string" } },
        "status": { "type": "string", "enum": ["draft", "pending", "published", "verified"], "default": "draft" },
        "created_at": { "type": "string" },
        "updated_at": { "type": "string" },
        "source_url": { "type": "string", "description": "Original research source" },
        "notes": { "type": "string", "description": "Internal notes" }
      }
    }
  }
}
```

---

## 4. Features

### 4.1 Core Features (P0)

| Feature | Description | User Story |
|---------|-------------|------------|
| **Search & Filter** | Filter by category, area, price, rating | "I want to find diving tours under 3000 THB near Chaweng" |
| **Listing Detail** | Full tour info with itinerary, pricing, contact | "Show me full details of this tour including what's included" |
| **Category Pages** | Dedicated pages per category | "Show me all wellness & spa options" |
| **Area Pages** | Filter by beach/area | "What tours operate from Bophut?" |
| **Direct Contact** | Phone, LINE, WhatsApp buttons | "I want to contact this operator directly" |
| **Static Export** | Generate static JSON/HTML | "Build static site from JSON data" |
| **SEO Optimization** | Meta tags, sitemap, schema markup | "Rank on Google for target keywords" |

### 4.2 Secondary Features (P1)

| Feature | Description |
|---------|-------------|
| **Map View** | Show all listings on interactive map |
| **Owner Verification** | Badge for verified businesses |
| **Related Listings** | "Similar tours you might like" |
| **Share Buttons** | Social sharing functionality |
| **Contact Form** | Web form (optional, respects privacy) |
| **FAQ Section** | Common questions per listing |

### 4.3 Future Features (P2)

| Feature | Description |
|---------|-------------|
| **User Reviews** | Traveler reviews & ratings |
| **Booking Integration** | External booking links |
| **Favorites** | Save listings to compare |
| **Price Alerts** | Notify on price drops |
| **Multi-language** | English, Thai, Chinese support |

---

## 5. Categories

### 5.1 Category Structure

| ID | Name | Icon | Description | Example Listings |
|----|------|------|-------------|------------------|
| diving-snorkeling | Diving & Snorkeling | 🤿 | Scuba courses, fun dives, snorkeling trips | Coral Dive Center, snorkel trips to Koh Tao |
| island-hopping | Island Hopping | 🚤 | Day trips to Ang Thong, Koh Phangan | Ang Thong Marine Park tours |
| adventure | Adventure & Wildlife | 🏕️ | ATV, zip-line, elephant sanctuaries | Samui ATV Park, Elephant Jungle Sanctuary |
| wellness-spa | Wellness & Spa | 🧘 | Thai massage, spa, yoga, retreats | Health Land, Yoga Samui |
| food-tours | Food & Culture | 🍜 | Cooking classes, food tours, local experiences | Samui Cooking School |
| transport | Transportation | 🚗 | Taxis, transfers, car/bike rental | Samui Airport Transfer |
| accommodation | Accommodation | 🏨 | Hotels, resorts, villas | Verified hotels only |
| nightlife | Nightlife | 🌙 | Bars, clubs, beach clubs | Beach Republic |

### 5.2 Area Structure

| ID | Name | Coordinates | Notes |
|----|------|-------------|-------|
| chaweng | Chaweng | 9.5332, 100.0665 | Main tourist hub |
| lamai | Lamai | 9.4599, 100.0535 | South, spa district |
| bophut | Bophut (Fisherman's Village) | 9.5604, 100.0334 | French Quarter, restaurants |
| maenam | Maenam | 9.5718, 100.0426 | Northern beaches |
| choeng-mon | Choeng Mon | 9.5514, 100.0816 | Upscale, beach clubs |
| big-buddha | Big Buddha Beach | 9.5761, 100.0338 | Near airport |
| taling-ngam | Taling Ngam | 9.4142, 99.9591 | Southwest, luxury resorts |
| nathon | Nathon | 9.5368, 99.9342 | Capital, ferry terminal |
| lipa-noi | Lipa Noi | 9.4713, 99.9101 | West coast, sunset views |
| bang-por | Bang Por | 9.4991, 99.9767 | North coast, local feel |

---

## 6. Technical Architecture

### 6.1 Tech Stack

```
┌─────────────────────────────────────────────────────────┐
│                    FRONTEND                              │
│  Next.js 14 (App Router)    │  Tailwind CSS  │  TypeScript │
├─────────────────────────────────────────────────────────┤
│                    DATA LAYER                            │
│  JSON Files (data/listings.json)  │  Zod Validation  │
├─────────────────────────────────────────────────────────┤
│                  AUTOMATION (CLAWDBOT)                   │
│  Perplexity Search  │  Browser Crawl  │  LLM Processing │
├─────────────────────────────────────────────────────────┤
│                  DEPLOYMENT                              │
│  Vercel/Netlify    │  Static Export  │  CDN            │
└─────────────────────────────────────────────────────────┘
```

### 6.2 Folder Structure

```
kohsamui-directory/
├── data/
│   ├── listings.json          # Main data (auto-generated)
│   ├── categories.json        # Category definitions
│   ├── areas.json             # Area definitions
│   └── directory-config.json  # Project config
├── scripts/
│   ├── research.js            # Research workflow
│   ├── crawl.js               # Crawl operator websites
│   ├── process.js             # Data processing
│   ├── generate-listings.js   # Generate listings from crawl
│   └── validate.js            # Validate JSON schema
├── src/
│   ├── app/
│   │   ├── page.tsx           # Homepage
│   │   ├── layout.tsx         # Root layout
│   │   ├── globals.css        # Global styles
│   │   ├── search/
│   │   │   └── page.tsx       # Search results
│   │   ├── category/
│   │   │   └── [slug]/
│   │   │       └── page.tsx   # Category page
│   │   ├── area/
│   │   │   └── [slug]/
│   │   │       └── page.tsx   # Area page
│   │   ├── listing/
│   │   │   └── [slug]/
│   │   │       └── page.tsx   # Listing detail
│   │   └── api/
│   │       └── listings/
│   │           └── route.ts   # JSON API endpoint
│   ├── components/
│   │   ├── ListingCard.tsx
│   │   ├── SearchFilters.tsx
│   │   ├── CategoryIcon.tsx
│   │   ├── AreaBadge.tsx
│   │   ├── ContactButtons.tsx
│   │   ├── MapView.tsx
│   │   ├── PricingDisplay.tsx
│   │   └── SEOHead.tsx
│   ├── lib/
│   │   ├── listings.ts        # Data fetching utilities
│   │   ├── search.ts          # Search/filter logic
│   │   ├── types.ts           # TypeScript definitions
│   │   └── schema.ts          # Zod schemas
│   └── hooks/
│       └── useSearch.ts
├── public/
│   ├── images/                # Static images
│   └── robots.txt
├── scripts/                   # Build scripts
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
├── package.json
└── README.md
```

### 6.3 Data Flow

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  CLAWDBOT    │    │  CRAWL       │    │  PROCESS     │    │  GENERATE    │
│  RESEARCH    │────▶  OPERATORS   │────▶  DATA        │────▶  LISTINGS   │
│              │    │              │    │              │    │  JSON        │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
      │                   │                   │                   │
      │  Search queries   │  Browser crawl    │  LLM extract     │  Validated
      │  + Directories    │  + Extract data   │  + Format        │  JSON files
      ▼                   ▼                   ▼                   ▼
```

---

## 7. Automation Workflow

### 7.1 Research Phase

**Step 1: Market Research**
```bash
# Search for operators
clawdbot agent --message "Search for top 20 Koh Samui tour operators with websites" --local

# Research categories
for query in "Koh Samui diving schools" "Koh Samui island hopping" "Koh Samui cooking classes"; do
  clawdbot agent --message "Search: $query" --local
done
```

**Step 2: Collect Source URLs**
```json
{
  "operators": [
    { "name": "Samui Diving School", "url": "https://samuidiving.com", "category": "diving-snorkeling" },
    { "name": "Ang Thong Tours", "url": "https://angthongtours.com", "category": "island-hopping" }
  ]
}
```

### 7.2 Crawl Phase

**Step 3: Crawl Each Operator**
```bash
clawdbot browser open https://samuidiving.com
clawdbot browser snapshot
clawdbot agent --message "Extract tour details from this page" --local
```

### 7.3 Process Phase

**Step 4: Generate Listings**
```bash
node scripts/generate-listings.js
```

### 7.4 Output Phase

**Step 5: Static Export**
```bash
npm run build
# Generates static HTML + JSON files
```

---

## 8. Pricing Reference (Market Research)

| Category | Min (THB) | Max (THB) | Notes |
|----------|-----------|-----------|-------|
| Snorkeling Trip | 800 | 2,000 | Half day, includes equipment |
| Fun Dive | 2,500 | 4,000 | Two-tank dive |
| Open Water Course | 12,000 | 15,000 | 3-day certification |
| Island Hopping (Ang Thong) | 1,500 | 3,500 | Full day, includes lunch |
| ATV Adventure | 1,500 | 3,000 | 1-2 hour session |
| Elephant Sanctuary | 2,000 | 5,000 | Half/full day ethical experience |
| Cooking Class | 1,200 | 2,500 | Market visit + cooking |
| Thai Massage (1hr) | 500 | 800 | Traditional massage |
| Spa Package | 2,000 | 5,000 | 2-3 hour treatment |
| Airport Transfer | 500 | 1,500 | Sedan/Taxi |

---

## 9. SEO Strategy

### 9.1 Target Keywords

| Priority | Keyword | Intent |
|----------|---------|--------|
| P0 | things to do in Koh Samui | Informational |
| P0 | Koh Samui tours | Commercial |
| P0 | best tours Koh Samui | Commercial |
| P1 | Koh Samui activities | Informational |
| P1 | Koh Samui diving | Commercial |
| P1 | island hopping Koh Samui | Commercial |
| P2 | Koh Samui tour operators | Commercial |
| P2 | Koh Samui adventure activities | Informational |

### 9.2 SEO Elements

- **Meta tags** per page (title, description, OG tags)
- **Schema.org** markup for LocalBusiness and Product
- **Sitemap.xml** auto-generated
- **robots.txt** configured
- **Canonical URLs** for pagination
- **Alt text** for all images
- **Internal linking** between categories/areas/listings

---

## 10. Development Phases

### Phase 1: Foundation (Week 1)
- [ ] Set up Next.js project
- [ ] Create JSON schema
- [ ] Build data models
- [ ] Set up Clawdbot automation scripts

### Phase 2: Research & Data (Week 2)
- [ ] Research market and collect URLs
- [ ] Crawl top 50 operators
- [ ] Process and validate data
- [ ] Generate listings JSON

### Phase 3: Frontend (Week 3)
- [ ] Build core components
- [ ] Implement search/filter
- [ ] Create category/area pages
- [ ] Build listing detail pages

### Phase 4: Polish (Week 4)
- [ ] Add SEO metadata
- [ ] Performance optimization
- [ ] Mobile responsiveness
- [ ] Testing and bug fixes

### Phase 5: Launch (Week 5)
- [ ] Deploy to Vercel
- [ ] Submit to search engines
- [ ] Set up analytics
- [ ] Monitor and iterate

---

## 11. Budget

| Item | Cost | Notes |
|------|------|-------|
| Domain (kohsamui-directory.com) | ~$15/year | .com |
| Hosting (Vercel Pro) | $20/month | Static site |
| Tools | $0 | Clawdbot, Next.js, Tailwind |
| **Total** | **~$255/year** | |

---

## 12. Success Criteria

| Metric | Target | Measurement |
|--------|--------|-------------|
| Listings | 100+ verified | JSON data count |
| SEO Rankings | Page 1 for 3+ keywords | Google Search Console |
| Organic Traffic | 1,000 visitors/month | Analytics |
| Direct Inquiries | 50+/month | Contact tracking |
| Performance | Lighthouse 90+ | Core Web Vitals |

---

*Document generated with Clawdbot AI Assistant*
*January 27, 2026*
