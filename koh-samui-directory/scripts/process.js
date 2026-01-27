#!/usr/bin/env node

/**
 * Koh Samui Directory - Process Script
 * 
 * Transforms operator data into structured listings.json
 * 
 * Usage: node scripts/process.js
 */

const fs = require('fs');
const path = require('path');

// Configuration
const CONFIG = {
  operatorsFile: path.join(__dirname, '../data/operators.json'),
  listingsFile: path.join(__dirname, '../data/listings.json'),
  categoriesFile: path.join(__dirname, '../data/categories.json'),
  areasFile: path.join(__dirname, '../data/areas.json'),
  configFile: path.join(__dirname, '../data/directory-config.json'),
  outputDir: path.join(__dirname, '../data')
};

/**
 * Main processing function
 */
async function process() {
  console.log('📦 Koh Samui Directory - Data Processing\n');
  console.log('═'.repeat(60));
  
  // Load operators
  console.log('\n📂 Loading operators...');
  const operatorsData = JSON.parse(fs.readFileSync(CONFIG.operatorsFile, 'utf8'));
  const operators = operatorsData.operators;
  console.log(`   Loaded ${operators.length} operators`);
  
  // Load categories and areas
  const categories = JSON.parse(fs.readFileSync(CONFIG.categoriesFile, 'utf8'));
  const areas = JSON.parse(fs.readFileSync(CONFIG.areasFile, 'utf8'));
  
  // Transform operators to listings
  console.log('\n🔄 Transforming operators to listings...');
  const listings = [];
  
  for (const operator of operators) {
    if (operator.status !== 'pending') continue;
    
    const listing = transformOperator(operator, categories, areas);
    listings.push(listing);
    
    // Update operator status
    operator.status = 'processed';
    operator.listing_id = listing.id;
  }
  
  console.log(`   Transformed ${listings.length} listings`);
  
  // Validate listings
  console.log('\n✅ Validating listings...');
  const validation = validateListings(listings);
  
  if (validation.errors.length > 0) {
    console.log(`   ⚠️  ${validation.errors.length} validation errors`);
    validation.errors.forEach(err => console.log(`      - ${err}`));
  } else {
    console.log('   All listings validated successfully');
  }
  
  // Save listings
  console.log('\n💾 Saving listings...');
  const output = {
    listings: listings,
    metadata: {
      total: listings.length,
      categories: [...new Set(listings.map(l => l.category))],
      areas: [...new Set(listings.map(l => l.location.area))],
      last_updated: new Date().toISOString(),
      version: '1.0'
    }
  };
  
  fs.writeFileSync(CONFIG.listingsFile, JSON.stringify(output, null, 2));
  console.log(`   Saved ${listings.length} listings to ${CONFIG.listingsFile}`);
  
  // Save operators with updated status
  fs.writeFileSync(CONFIG.operatorsFile, JSON.stringify(operatorsData, null, 2));
  console.log('   Updated operator statuses');
  
  // Print summary
  console.log('\n\n📊 PROCESSING SUMMARY');
  console.log('═'.repeat(60));
  console.log(`Total Listings: ${listings.length}`);
  
  console.log('\nBy Category:');
  const byCategory = listings.reduce((acc, l) => {
    acc[l.category] = (acc[l.category] || 0) + 1;
    return acc;
  }, {});
  for (const [cat, count] of Object.entries(byCategory)) {
    console.log(`  ${cat}: ${count}`);
  }
  
  console.log('\nBy Area:');
  const byArea = listings.reduce((acc, l) => {
    acc[l.location.area] = (acc[l.location.area] || 0) + 1;
    return acc;
  }, {});
  for (const [area, count] of Object.entries(byArea)) {
    console.log(`  ${area}: ${count}`);
  }
  
  console.log('\nBy Status:');
  const byStatus = listings.reduce((acc, l) => {
    acc[l.status] = (acc[l.status] || 0) + 1;
    return acc;
  }, {});
  for (const [status, count] of Object.entries(byStatus)) {
    console.log(`  ${status}: ${count}`);
  }
  
  console.log('\nNext Steps:');
  console.log('  1. Review and verify listings');
  console.log('  2. Run: npm run build (Next.js static export)');
  console.log('  3. Deploy to Vercel');
  console.log('═'.repeat(60));
}

/**
 * Transform operator to listing
 */
function transformOperator(operator, categories, areas) {
  const category = categories.find(c => c.id === operator.category) || categories[0];
  const area = areas.find(a => a.id === 'chaweng') || areas[0];
  
  return {
    id: operator.listing_id || generateId(),
    slug: slugify(operator.name),
    name: operator.name,
    category: operator.category,
    description: operator.research_data?.description || `Professional ${category.name.toLowerCase()} services in Koh Samui.`,
    short_description: operator.research_data?.description?.substring(0, 100) || `${category.name} provider in Koh Samui.`,
    location: {
      area: 'chaweng',
      address: 'Address to be confirmed',
      coordinates: area.coordinates
    },
    itinerary: getDefaultItinerary(operator.category),
    pricing: getDefaultPricing(operator.category),
    owner: {
      name: 'Owner name to be verified',
      company: operator.name,
      verified: false,
      years_in_business: null
    },
    contact: {
      phone: 'Phone to be confirmed',
      email: 'contact@example.com',
      website: operator.url,
      line_id: null
    },
    media: {
      hero_image: `/images/listings/${slugify(operator.name)}-hero.jpg`,
      gallery: []
    },
    reviews: {
      rating: null,
      count: 0
    },
    tags: [category.id],
    highlights: [`Professional ${category.name}`],
    status: 'draft',
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
    source_url: operator.url,
    notes: 'Auto-generated from research'
  };
}

/**
 * Get default itinerary based on category
 */
function getDefaultItinerary(category) {
  const defaults = {
    'diving-snorkeling': {
      duration: 'Full Day',
      highlights: ['Dive sites', 'Equipment included', 'Lunch provided'],
      schedule: 'Pickup 8:00 AM, dive 9:00 AM - 3:00 PM',
      start_times: ['8:00 AM'],
      days_operated: ['Daily'],
      inclusions: ['Hotel pickup', 'Equipment', 'Lunch', 'Insurance'],
      exclusions: ['Personal expenses'],
      what_to_bring: ['Swimsuit', 'Towel', 'Sunscreen']
    },
    'island-hopping': {
      duration: 'Full Day',
      highlights: ['Island exploration', 'Snorkeling', 'Beach time'],
      schedule: 'Pickup 8:00 AM, boat 9:00 AM - 5:00 PM',
      start_times: ['8:00 AM'],
      days_operated: ['Daily except Monday'],
      inclusions: ['Transfer', 'Lunch', 'Guide'],
      exclusions: ['Park fees'],
      what_to_bring: ['Swimsuit', 'Camera', 'Towel']
    },
    'food-tours': {
      duration: 'Half Day',
      highlights: ['Market visit', 'Cooking', 'Meal'],
      schedule: 'Market 9:00 AM, Cooking 10:00 AM - 1:00 PM',
      start_times: ['9:00 AM'],
      days_operated: ['Daily'],
      inclusions: ['Ingredients', 'Recipe book', 'Meal'],
      exclusions: ['Personal expenses'],
      what_to_bring: ['Appetite']
    }
  };
  
  return defaults[category] || {
    duration: 'To be confirmed',
    highlights: [],
    schedule: 'To be confirmed',
    start_times: [],
    days_operated: [],
    inclusions: [],
    exclusions: [],
    what_to_bring: []
  };
}

/**
 * Get default pricing based on category
 */
function getDefaultPricing(category) {
  const defaults = {
    'diving-snorkeling': { adult: 3500, child: null, currency: 'THB' },
    'island-hopping': { adult: 2200, child: 1500, currency: 'THB' },
    'adventure': { adult: 2500, child: 1500, currency: 'THB' },
    'wellness-spa': { adult: 500, currency: 'THB' },
    'food-tours': { adult: 1500, child: 1000, currency: 'THB' },
    'transport': { adult: 600, currency: 'THB' }
  };
  
  return defaults[category] || { adult: 1000, currency: 'THB' };
}

/**
 * Validate listings
 */
function validateListings(listings) {
  const errors = [];
  
  for (let i = 0; i < listings.length; i++) {
    const listing = listings[i];
    
    if (!listing.id) errors.push(`Listing ${i}: Missing ID`);
    if (!listing.name) errors.push(`Listing ${i}: Missing name`);
    if (!listing.category) errors.push(`Listing ${i}: Missing category`);
    if (!listing.location?.area) errors.push(`Listing ${i}: Missing location area`);
    if (!listing.contact?.phone) errors.push(`Listing ${i}: Missing contact phone`);
    
    // Check URL formats
    if (listing.source_url && !isValidUrl(listing.source_url)) {
      errors.push(`Listing ${i}: Invalid source URL`);
    }
  }
  
  // Check for duplicate IDs
  const ids = listings.map(l => l.id);
  const duplicates = ids.filter((id, i) => ids.indexOf(id) !== i);
  if (duplicates.length > 0) {
    errors.push(`Duplicate IDs found: ${[...new Set(duplicates)].join(', ')}`);
  }
  
  return { valid: errors.length === 0, errors };
}

/**
 * Generate slug from name
 */
function slugify(name) {
  return name
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '');
}

/**
 * Generate unique ID
 */
function generateId() {
  const timestamp = Date.now().toString(36);
  const random = Math.random().toString(36).substr(2, 4);
  return `${timestamp}-${random}`.toUpperCase().padStart(12, '0');
}

/**
 * Validate URL
 */
function isValidUrl(string) {
  try {
    new URL(string);
    return true;
  } catch {
    return false;
  }
}

// Run processing
process().catch(console.error);
