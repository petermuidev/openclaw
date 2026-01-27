/**
 * Stage 4: Verify
 * Command: npm run verify
 * Agent: verify-agent
 * Output: data/quality-report.json
 */

const fs = require('fs');
const path = require('path');

const LISTINGS_DIR = path.join(__dirname, '..', 'data', 'listings');
const REPORT_FILE = path.join(__dirname, '..', 'data', 'quality-report.json');

console.log('✅ STAGE 4: VERIFY');
console.log('='.repeat(40));
console.log(`Input: ${LISTINGS_DIR}`);
console.log(`Output: ${REPORT_FILE}`);
console.log('');

// Required fields with weights
const REQUIRED_FIELDS = {
  name: { required: true, weight: 10 },
  category: { required: true, weight: 10 },
  area: { required: true, weight: 5 },
  description: { required: true, weight: 10 },
  'contact.phone': { required: true, weight: 10 },
  'contact.line': { required: false, weight: 5 },
  'contact.website': { required: true, weight: 10 },
  'contact.email': { required: false, weight: 5 }
};

// Read index
const index = JSON.parse(fs.readFileSync(path.join(LISTINGS_DIR, 'index.json'), 'utf-8'));
const listings = index.listings;

const report = {
  timestamp: new Date().toISOString(),
  total_listings: listings.length,
  quality_scores: [],
  missing_fields: {},
  issues: []
};

let totalScore = 0;

for (const listing of listings) {
  const score = { listing: listing.slug, score: 0, max: 0, issues: [] };

  for (const [field, config] of Object.entries(REQUIRED_FIELDS)) {
    const parts = field.split('.');
    let value = listing;

    for (const part of parts) {
      value = value?.[part];
    }

    const points = config.required ? config.weight : config.weight / 2;
    score.max += points;

    if (value && value.trim()) {
      score.score += points;
    } else if (config.required) {
      score.issues.push(`Missing required: ${field}`);
    }
  }

  report.quality_scores.push(score);
  totalScore += (score.score / score.max) * 100;
}

report.average_score = Math.round(totalScore / listings.length);
report.passed = report.average_score >= 70;

fs.writeFileSync(REPORT_FILE, JSON.stringify(report, null, 2));

console.log(`📊 Quality Score: ${report.average_score}%`);
console.log(`✅ Passed: ${report.passed ? 'YES' : 'NO'}`);
console.log('');
console.log('Details:');
for (const score of report.quality_scores.slice(0, 5)) {
  const percent = Math.round((score.score / score.max) * 100);
  console.log(`  ${score.listing}: ${percent}%`);
}
if (report.quality_scores.length > 5) {
  console.log(`  ... and ${report.quality_scores.length - 5} more`);
}
console.log('');
console.log('✅ Verification complete!');
