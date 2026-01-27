/**
 * Stage 1: Research
 * Command: npm run research
 * Agent: research-agent
 * Output: data/operators/raw/{category}.json
 */

const fs = require('fs');
const path = require('path');

const LISTINGS_DIR = path.join(__dirname, '..', 'data', 'listings');
const OUTPUT_DIR = path.join(__dirname, '..', 'data', 'operators', 'raw');
const CATEGORIES = ['diving', 'island-hopping', 'cooking', 'spa', 'adventure', 'transport'];

console.log('🔍 STAGE 1: RESEARCH');
console.log('='.repeat(40));
console.log(`Input: ${LISTINGS_DIR}`);
console.log(`Output: ${OUTPUT_DIR}`);
console.log('');

// Ensure output directory exists
if (!fs.existsSync(OUTPUT_DIR)) {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });
}

// Read all listing folders
const listingFolders = fs.readdirSync(LISTINGS_DIR).filter(f => {
  return fs.statSync(path.join(LISTINGS_DIR, f)).isDirectory();
});

// Group by category
const byCategory = {};
for (const folder of listingFolders) {
  const listingFile = path.join(LISTINGS_DIR, folder, 'listing.json');
  if (!fs.existsSync(listingFile)) continue;

  const listing = JSON.parse(fs.readFileSync(listingFile, 'utf-8'));
  const cat = listing.category || 'unknown';

  if (!byCategory[cat]) byCategory[cat] = [];
  byCategory[cat].push({
    name: listing.name,
    website: listing.contact?.website || '',
    description: listing.description || '',
    area: listing.location?.area || '',
    slug: listing.slug,
    status: 'researched'
  });
}

console.log('📊 Found listings by category:');
for (const [cat, ops] of Object.entries(byCategory)) {
  console.log(`  ${cat}: ${ops.length} operators`);
}
console.log('');

// Save each category
for (const cat of CATEGORIES) {
  const outputFile = path.join(OUTPUT_DIR, `${cat}.json`);
  console.log(`📁 Saving: ${cat}...`);

  // Find matching category
  let matchingCat = Object.keys(byCategory).find(k =>
    k.includes(cat) || cat.includes(k.split('-')[0])
  );

  const operators = matchingCat ? byCategory[matchingCat] : [];

  const output = {
    category: cat,
    timestamp: new Date().toISOString(),
    count: operators.length,
    operators: operators
  };

  fs.writeFileSync(outputFile, JSON.stringify(output, null, 2));
  console.log(`  ✅ ${operators.length} operators saved`);
}

console.log('');
console.log('✅ Research complete!');
console.log('');
console.log('Next: Run npm run crawl');
