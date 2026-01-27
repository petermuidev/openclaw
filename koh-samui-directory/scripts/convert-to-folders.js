const fs = require('fs');
const path = require('path');

const DATA_DIR = path.join(__dirname, '..', 'data');
const listingsPath = path.join(DATA_DIR, 'listings.json');

const data = JSON.parse(fs.readFileSync(listingsPath, 'utf-8'));

for (const listing of data.listings) {
  const slugDir = path.join(DATA_DIR, listing.slug);

  if (!fs.existsSync(slugDir)) {
    fs.mkdirSync(slugDir, { recursive: true });
  }

  const listingJson = JSON.stringify(listing, null, 2);
  fs.writeFileSync(path.join(slugDir, 'listing.json'), listingJson);

  console.log(`✅ ${listing.slug}/listing.json`);
}

console.log(`\n📊 Total: ${data.listings.length} listings`);
