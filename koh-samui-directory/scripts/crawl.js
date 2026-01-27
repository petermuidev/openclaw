/**
 * Stage 2: Crawl
 * Command: npm run crawl
 * Agent: crawl-agent
 * Output: data/operators/crawled/{slug}.json
 */

const fs = require('fs');
const path = require('path');

const INPUT_DIR = path.join(__dirname, '..', 'data', 'operators', 'raw');
const OUTPUT_DIR = path.join(__dirname, '..', 'data', 'operators', 'crawled');

console.log('🕷️ STAGE 2: CRAWL');
console.log('='.repeat(40));
console.log(`Input: ${INPUT_DIR}`);
console.log(`Output: ${OUTPUT_DIR}`);
console.log('');

// Ensure output directory exists
if (!fs.existsSync(OUTPUT_DIR)) {
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });
}

// Read all category files
const categoryFiles = fs.readdirSync(INPUT_DIR).filter(f => f.endsWith('.json'));

for (const catFile of categoryFiles) {
  const catName = catFile.replace('.json', '');
  const inputData = JSON.parse(fs.readFileSync(path.join(INPUT_DIR, catFile), 'utf-8'));

  console.log(`📁 Crawling: ${catName} (${inputData.operators.length} operators)`);

  for (const op of inputData.operators) {
    const slug = op.name.toLowerCase().replace(/[^a-z0-9]+/g, '-').substring(0, 50);
    const outputFile = path.join(OUTPUT_DIR, `${slug}.json`);

    // In production, this would use clawdbot browser to visit the website
    // For now, we create a placeholder with the researched data

    const crawled = {
      ...op,
      slug: slug,
      crawled_at: new Date().toISOString(),
      website_content: {},  // Would contain parsed website content
      reviews: {},          // Would contain review data
      status: 'crawled'
    };

    fs.writeFileSync(outputFile, JSON.stringify(crawled, null, 2));
    console.log(`  ✅ ${slug}`);
  }
}

console.log('');
console.log('✅ Crawl complete!');
console.log('');
console.log('Next: Run npm run build');
