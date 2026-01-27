/**
 * Stage 3: Build
 * Command: npm run build
 * Agent: build-agent
 * Output: data/listings/{slug}.json and data/listings/index.json
 */

const fs = require('fs');
const path = require('path');

const CRAWLED_DIR = path.join(__dirname, '..', 'data', 'operators', 'crawled');
const OUTPUT_DIR = path.join(__dirname, '..', 'data', 'listings');

console.log('📝 STAGE 3: BUILD');
console.log('='.repeat(40));
console.log(`Input: ${CRAWLED_DIR}`);
console.log(`Output: ${OUTPUT_DIR}`);
console.log('');

// Ensure output directory exists
if (!fs.existsSync(OUTPUT_DIR)) {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });
}

// Read all crawled files
const crawledFiles = fs.readdirSync(CRAWLED_DIR).filter(f => f.endsWith('.json'));
const listings = [];

for (const file of crawledFiles) {
  const crawled = JSON.parse(fs.readFileSync(path.join(CRAWLED_DIR, file), 'utf-8'));

  // Transform to listing format
  const listing = {
    id: crawled.slug,
    slug: crawled.slug,
    name: crawled.name,
    category: mapCategory(crawled.category),
    area: crawled.area || 'unknown',
    description: crawled.description,
    contact: {
      phone: '',
      line: '',
      website: crawled.website,
      email: ''
    },
    status: 'draft',
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString()
  };

  // Save individual listing
  fs.writeFileSync(path.join(OUTPUT_DIR, `${crawled.slug}.json`), JSON.stringify(listing, null, 2));
  listings.push(listing);
  console.log(`  ✅ ${crawled.slug}.json`);
}

// Save index
const index = {
  listings: listings,
  metadata: {
    total: listings.length,
    categories: [...new Set(listings.map(l => l.category))],
    areas: [...new Set(listings.map(l => l.area))],
    last_updated: new Date().toISOString(),
    version: '1.0.0'
  }
};

fs.writeFileSync(path.join(OUTPUT_DIR, 'index.json'), JSON.stringify(index, null, 2));
console.log('');
console.log(`✅ Built ${listings.length} listings`);
console.log(`✅ Created index.json`);
console.log('');
console.log('Next: Run npm run verify');

function mapCategory(cat) {
  const map = {
    'diving': 'diving-snorkeling',
    'island-hopping': 'island-hopping',
    'cooking': 'food-tours',
    'spa': 'wellness-spa',
    'adventure': 'adventure',
    'transport': 'transport'
  };
  return map[cat] || cat;
}
