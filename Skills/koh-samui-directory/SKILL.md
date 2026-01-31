---
name: Koh Samui Directory Pipeline
description: Automated workflow to research, crawl, and generate travel directory listings for Koh Samui tour operators. Executes multi-step pipeline using Clawdbot tools.
read_when:
  - Building travel directory
  - Researching tour operators
  - Automating data collection
  - Generating static JSON listings
metadata: {"clawdbot":{"emoji":"🏝️","requires":{"bins":["node","npm"]}},"permissions":{"tools":["bash","read","write","web_search","clawdbot_agent"]}}
allowed-tools: Bash(koh-samui-directory-pipeline:*),Read(koh-samui-directory:*),Write(koh-samui-directory:*),WebSearch(koh-samui-directory:*),ClawdbotAgent(koh-samui-directory:*)
---

# Koh Samui Directory Pipeline Skill

## Overview

This skill orchestrates a complete automation pipeline to build a travel directory for Koh Samui tour operators. It researches operators, crawls websites, extracts data, and generates static JSON listings.

## Usage

```bash
# Run the complete pipeline
clawdbot agent --message "Run the Koh Samui directory pipeline" --deliver

# Research only
clawdbot agent --message "Research Koh Samui tour operators for categories: diving, island hopping, cooking, spa" --deliver

# Crawl specific operator
clawdbot agent --message "Crawl https://coraldivethailand.com and extract tour details" --deliver

# Generate listings
clawdbot agent --message "Process operator data and generate listings.json" --deliver
```

## Pipeline Steps

### Step 1: Research Operators
Search for tour operators across 7 categories:
- Diving & Snorkeling
- Island Hopping
- Cooking Classes
- Spa & Wellness
- Adventure (ATV, Elephant)
- Transportation
- Accommodation

### Step 2: Crawl Websites
Visit operator websites and extract:
- Tour details & itineraries
- Pricing information
- Contact details (phone, email, LINE)
- Location/area
- Photos/references

### Step 3: Process Data
Transform raw data into structured listings:
- Validate against JSON schema
- Generate slugs and IDs
- Add metadata
- Calculate pricing ranges

### Step 4: Generate Output
Create final `listings.json` with:
- Complete listing objects
- Metadata (total, categories, areas)
- Pricing ranges by category
- Source tracking

## Output Files

| File | Location | Description |
|------|----------|-------------|
| `operators.json` | `~/clawd/koh-samui-directory/` | Raw operator research data |
| `listings.json` | `~/clawd/koh-samui-directory/` | Final structured listings |
| `metadata.json` | `~/clawd/koh-samui-directory/` | Pipeline metadata |

## Categories Supported

| Category | ID | Price Range (THB) |
|----------|-----|-------------------|
| Diving & Snorkeling | `diving-snorkeling` | 1,500 - 5,000 |
| Island Hopping | `island-hopping` | 1,200 - 3,500 |
| Food Tours | `food-tours` | 1,200 - 2,500 |
| Wellness & Spa | `wellness-spa` | 500 - 5,000 |
| Adventure | `adventure` | 1,500 - 5,000 |
| Transportation | `transport` | 500 - 2,000 |

## Areas Covered

- Chaweng, Lamai, Bophut, Maenam, Choeng Mon, Big Buddha, Taling Ngam, Nathon, Lipa Noi, Bang Por

## Example Output

```json
{
  "listings": [
    {
      "id": "001",
      "slug": "coral-dive-center-chaweng",
      "name": "Coral Dive Center",
      "category": "diving-snorkeling",
      "location": { "area": "chaweng" },
      "pricing": { "adult": 3500, "currency": "THB" },
      "contact": { "phone": "+66...", "line_id": "..." },
      "status": "draft"
    }
  ],
  "metadata": {
    "total": 6,
    "categories": ["diving-snorkeling", "island-hopping"],
    "areas": ["chaweng", "nathon"]
  }
}
```

## Integration with Next.js

The generated `listings.json` is ready for Next.js static export:
- Place in `src/data/listings.json`
- Use in pages: `page.tsx`, `category/[slug]/page.tsx`, `listing/[slug]/page.tsx`
- Deploy to Verozel/Netlify with static export

## Troubleshooting

- **No results**: Check Perplexity API key is configured
- **Crawl errors**: Some sites may block automated access
- **Schema validation**: Data may need manual review

## See Also

- `clawdbot-guide.html` - Full Clawdbot documentation
- `koh-samui-directory/PRD.md` - Product requirements
- `koh-samui-directory/ARCHITECTURE.md` - Technical architecture
