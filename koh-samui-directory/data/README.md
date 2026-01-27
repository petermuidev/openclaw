# Koh Samui Directory - Data Layer

Pure data layer. No UI dependencies. Can be used standalone.

## Quick Start

```bash
cd data
npm install
```

## Commands

| Command | Description | Output |
|---------|-------------|--------|
| `npm run research` | Research operators via web search | `operators/raw/*.json` |
| `npm run crawl` | Crawl operator websites | `operators/crawled/*.json` |
| `npm run build` | Build listings | `listings/*.json` |
| `npm run verify` | Check quality | `quality-report.json` |
| `npm run reset` | Full pipeline | All above |

## Folder Structure

```
data/
├── listings/              # Final listings (used by UI)
│   ├── index.json         # All listings + metadata
│   └── {slug}.json        # Individual listing
├── operators/             # Raw data (intermediate)
│   ├── raw/               # Research output
│   └── crawled/           # Crawl output
├── categories.json        # Category definitions
└── areas.json             # Area definitions
```

## Listing Schema

```json
{
  "id": "silent-divers-chaweng",
  "slug": "silent-divers-chaweng",
  "name": "Silent Divers",
  "category": "diving-snorkeling",
  "area": "chaweng",
  "description": "PADI dive center...",
  "contact": {
    "phone": "+66...",
    "line": "silentdivers",
    "website": "https://..."
  },
  "status": "draft"
}
```

## Agent Assignments

| Stage | Agent | Tool |
|-------|-------|------|
| Research | research-agent | web_search (Perplexity) |
| Crawl | crawl-agent | browser |
| Build | build-agent | node scripts |
| Verify | verify-agent | node scripts |

## Integration with UI

The UI layer (src/) reads from `data/listings/index.json`:

```javascript
import data from '../data/listings/index.json';
```

Or copy `data/listings/` to `src/data/` for static build.
