const fs = require('fs');
const path = require('path');

const OUTPUT_FILE = path.join(process.env.HOME || process.env.USERPROFILE, 'clawd', 'koh_samui_operators_output.json');
const DATA_DIR = path.join(__dirname, '..', 'data');

const operators = JSON.parse(fs.readFileSync(OUTPUT_FILE, 'utf-8'));

const categoryMap = {
  'diving': 'diving-snorkeling',
  'island_hopping': 'island-hopping',
  'cooking_class': 'food-tours',
  'spa': 'wellness-spa',
  'atv_adventure': 'adventure',
  'elephant_sanctuary': 'adventure',
  'airport_transfer': 'transport'
};

let count = 0;
for (const op of operators) {
  const slug = op.name.toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
    .substring(0, 50);

  const areaSlug = op.location_area.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  const fullSlug = `${slug}-${areaSlug}`;

  const listingDir = path.join(DATA_DIR, fullSlug);
  if (!fs.existsSync(listingDir)) {
    fs.mkdirSync(listingDir, { recursive: true });
  }

  const listing = {
    id: fullSlug,
    slug: fullSlug,
    name: op.name,
    category: categoryMap[op.category] || op.category,
    description: op.description,
    short_description: op.description.substring(0, 150) + '...',
    location: {
      area: areaSlug,
      address: '',
      coordinates: { lat: null, lng: null }
    },
    contact: {
      phone: op.phone || '',
      line: op.line_id || '',
      email: op.email || '',
      website: op.website || '',
      facebook: op.facebook || ''
    },
    status: 'draft',
    source_url: op.website
  };

  fs.writeFileSync(path.join(listingDir, 'listing.json'), JSON.stringify(listing, null, 2));
  console.log(`✅ ${fullSlug}/listing.json`);
  count++;
}

console.log(`\n📊 Total: ${count} listings created`);
