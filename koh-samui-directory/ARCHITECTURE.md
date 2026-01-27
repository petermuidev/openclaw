# Koh Samui Directory - Pipeline Architecture

## Overview

Modular pipeline for building travel directory. Each stage is independent and can loop back when data is missing.

```
┌─────────────────────────────────────────────────────────────────────┐
│                     KOH SAMUI DIRECTORY PIPELINE                     │
└─────────────────────────────────────────────────────────────────────┘

    ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
    │ RESEARCH │────▶│  CRAWL   │────▶│  PARSE   │────▶│  PARSE   │
    │          │     │          │     │ WEBSITE  │     │  REVIEWS │
    └──────────┘     └──────────┘     └──────────┘     └──────────┘
         │                │                │                │
         │◀───────────────│◀──────────────│◀───────────────│
         │   MISSING?     │   MISSING?     │   MISSING?     │   MISSING?
         │                │                │                │
    ┌────┴────┐     ┌────┴────┐     ┌────┴────┐     ┌────┴────┐
    │  REPEAT │     │  REPEAT │     │  REPEAT │     │  REPEAT │
    │  SEARCH │     │  CRAWL  │     │  PARSE  │     │  PARSE  │
    └─────────┘     └─────────┘     └─────────┘     └─────────┘

    ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
    │   GET    │────▶│  CREATE  │────▶│  BUILD   │────▶│ VERIFY   │
    │  IMAGES  │     │   JSON   │     │   SITE   │     │  QUALITY │
    └──────────┘     └──────────┘     └──────────┘     └──────────┘
         │                │                │                │
         │◀───────────────│◀──────────────│◀───────────────│
         │   MISSING?     │   MISSING?     │   FAILED?      │   FAILED?
         │                │                │                │
    ┌────┴────┐     ┌────┴────┐     ┌────┴────┐     ┌────┴────┐
    │  REPEAT │     │  REPEAT │     │  REPEAT │     │  REPEAT │
    │  IMAGE  │     │  CREATE │     │  BUILD  │     │ VERIFY  │
    └─────────┘     └─────────┘     └─────────┘     └─────────┘
```

## Stage Descriptions

### Stage 1: RESEARCH
**Purpose:** Discover tour operators across categories
**Input:** Category list
**Output:** `data/operators_raw.json`
**Loop back if:** No results found, incomplete data
**Commands:**
```bash
# Research all categories
clawdbot agent --message "Research Koh Samui tour operators for: diving, island hopping, cooking, spa, adventure, transport. Find name, website, phone, email, LINE. Return JSON." --local

# Research specific category
clawdbot agent --message "Research Koh Samui diving operators. Find 10+ PADI centers with websites and contact info. Return JSON array." --local
```

### Stage 2: CRAWL
**Purpose:** Visit operator websites to extract details
**Input:** operators_raw.json
**Output:** data/operators_crawled.json
**Loop back if:** Website inaccessible, timeout, need more pages
**Commands:**
```bash
# Crawl all operators
node scripts/crawl-operators.js

# Crawl specific operator
clawdbot agent --message "Crawl https://silentdivers.com and extract: tour types, prices, itinerary, contact info, photos. Return JSON." --local
```

### Stage 3: PARSE REVIEWS
**Purpose:** Get reviews from Google, TripAdvisor, Facebook
**Input:** operator websites
**Output:** data/operators_reviews.json
**Loop back if:** No reviews found, ratings missing
**Commands:**
```bash
# Get reviews
clawdbot agent --message "Find Google reviews and TripAdvisor ratings for: Discovery Dive Center Chaweng, Samui Elephant Sanctuary. Return JSON with rating, count, review_count." --local
```

### Stage 4: GET IMAGES
**Purpose:** Download or reference hero images
**Input:** operator list
**Output:** images/ folder
**Loop back if:** Image missing, broken link
**Commands:**
```bash
# Generate images with AI
clawdbot chutes-image-gen --prompt "Professional diving center on tropical beach, Koh Samui, sunny day, dive equipment visible" --output images/silent-divers-hero.png

# Or use web_fetch
clawdbot agent --message "Find hero image URL for Silent Divers Koh Samui. Return the direct image URL." --local
```

### Stage 5: CREATE JSON
**Purpose:** Build final listing.json files per slug
**Input:** all collected data
**Output:** data/{slug}/listing.json
**Loop back if:** Missing required fields, validation failed
**Commands:**
```bash
# Generate all listings
node scripts/create-listings.js

# Generate specific listing
node scripts/create-listing.js --slug "silent-divers-chaweng"
```

### Stage 6: BUILD SITE
**Purpose:** Build Next.js static site
**Input:** data/{slug}/listing.json
**Output:** out/ folder
**Loop back if:** Build failed, missing data
**Commands:**
```bash
npm run build && npm run export
```

### Stage 7: VERIFY QUALITY
**Purpose:** Check data quality and completeness
**Input:** data/ folder
**Output:** quality_report.json
**Loop back if:** Quality score low, missing critical fields
**Commands:**
```bash
# Run verification
node scripts/verify-quality.js

# Check specific issues
clawdbot agent --message "Check these listings for missing data: silent-divers-chaweng, smiley-cook-bophut. Which fields are missing? Return JSON." --local
```

## Data Flow

```
RESEARCH ──▶ CRAWL ──▶ PARSE ──▶ PARSE ──▶  GET   ──▶  CREATE ──▶ BUILD
              │        REVIEWS        IMAGES           JSON
              │           │              │              │
              │           ▼              ▼              ▼
              │     operators_     images/{slug}   data/{slug}   out/
              │     reviews.json    /hero.png      /listing.json /index.html
              │           │              │              │
              │           ▼              ▼              ▼
              │     operators_    operators_      quality_     quality_
              │     crawled.json   images.json     report.json  checked
              │           │              │              │
              ▼           ▼              ▼              ▼
         operators_   ◀────── loop back ──────▶   ◀─────────▶
         raw.json     if missing data            if failed
```

## Quality Gates

| Field | Required | Quality Score |
|-------|----------|---------------|
| name | ✓ | +5 |
| website | ✓ | +10 |
| description | ✓ | +10 |
| phone | ✓ | +10 |
| line_id | ✗ | +5 |
| email | ✗ | +5 |
| price | ✓ | +10 |
| reviews | ✗ | +5 |
| hero_image | ✗ | +5 |

**Minimum quality score:** 40/100

## Running the Pipeline

### Full Pipeline (Automatic)
```bash
# Option 1: Clawdbot skill
clawdbot agent --message "Run the Koh Samui Directory Pipeline" --deliver

# Option 2: Lobster workflow
clawdbot agent --message "Run the koh-samui-directory pipeline" --local

# Option 3: Manual step-by step
./run-pipeline-manual.sh
```

### Individual Stages
```bash
# Stage 1: Research
clawdbot agent --message "Research Koh Samui tour operators for all 7 categories" --local

# Stage 2: Crawl
node scripts/crawl-operators.js

# Stage 3: Parse reviews
node scripts/parse-reviews.js

# Stage 4: Get images
node scripts/get-images.js

# Stage 5: Create JSON
node scripts/create-listings.js

# Stage 6: Build site
npm run build && npm run export

# Stage 7: Verify
node scripts/verify-quality.js
```

## Directory Structure

```
koh-samui-directory/
├── data/
│   ├── {slug}/           # One folder per listing
│   │   └── listing.json  # Complete listing data
│   ├── operators_raw.json      # Stage 1 output
│   ├── operators_crawled.json  # Stage 2 output
│   ├── operators_reviews.json  # Stage 3 output
│   └── quality_report.json     # Stage 7 output
├── images/
│   └── {slug}/
│       └── hero.png      # Hero images
├── scripts/
│   ├── research.sh              # Stage 1
│   ├── crawl-operators.js       # Stage 2
│   ├── parse-reviews.js         # Stage 3
│   ├── get-images.js            # Stage 4
│   ├── create-listings.js       # Stage 5
│   └── verify-quality.js        # Stage 7
├── src/                  # Next.js source
├── out/                  # Static export
└── ARCHITECTURE.md       # This file
```

## Loop Back Examples

```bash
# If Stage 1 (Research) found no diving operators:
# → Repeat with different search terms
clawdbot agent --message "Research Koh Samui scuba diving PADI 5-star centers. Try alternative search: 'Koh Samui dive schools', 'Chaweng diving', 'Bophut snorkeling tours'" --local

# If Stage 2 (Crawl) couldn't access a website:
# → Try alternative URL or skip
clawdbot agent --message "Crawl https://silentdivers.com again or find alternative source. If failed, note in operators_crawled.json with status: 'retry'" --local

# If Stage 4 (Images) missing for some operators:
# → Generate with AI or find alternatives
clawdbot chutes-image-gen --prompt "Professional Thai cooking class in Koh Samui, fresh ingredients, happy chef" --output images/smiley-cook-hero.png

# If Stage 7 (Verify) quality score < 40:
# → Re-run specific stages for low-quality listings
node scripts/create-listings.js --only-missing
```

## Monitoring

```bash
# Check pipeline status
cat data/operators_raw.json | jq 'length'   # Stage 1
cat data/operators_crawled.json | jq 'length' # Stage 2
cat data/quality_report.json | jq '.score'   # Stage 7

# List all listings
ls data/*/listing.json | wc -l

# Find missing data
jq 'map(select(.phone == "" or .line_id == ""))' data/*/listing.json
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Next.js 14, TypeScript, Tailwind CSS |
| Data | Static JSON per slug |
| Research | Clawdbot + Perplexity (sonar-pro) |
| Crawling | Clawdbot Browser |
| Images | Chutes Image Gen / web_fetch |
| Hosting | Vercel (Static Export) |

---

*Architecture document for Koh Samui Travel Directory*
*January 27, 2026*
