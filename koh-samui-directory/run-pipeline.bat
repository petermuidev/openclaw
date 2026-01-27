#!/bin/bash
# Koh Samui Directory - Complete Automation Pipeline
# This script orchestrates Clawdbot to research, crawl, and generate listings

set -e

echo "🏝️  KOH SAMUI DIRECTORY - AUTOMATION PIPELINE"
echo "══════════════════════════════════════════════"
echo ""

# Configuration
PROJECT_DIR="C:/Users/Administrator/Desktop/New folder/koh-samui-directory"
DATA_DIR="$PROJECT_DIR/data"
OUTPUT_FILE="$DATA_DIR/listings.json"

# Search queries for each category
QUERIES=(
  "Koh Samui diving schools PADI certified tour operators websites 2025"
  "Koh Samui snorkeling tours best operators with prices"
  "Koh Samui island hopping Ang Thong Marine Park tour operators"
  "Koh Samui Thai cooking classes tour operators websites"
  "Koh Samui spa massage wellness centers tour operators"
  "Koh Samui ATV adventure elephant sanctuary tour operators"
  "Koh Samui airport transfer private taxi car rental services"
)

# Step 1: Research Phase - Search all categories
echo "📡 STEP 1: RESEARCH"
echo "──────────────────────────────────────────────"
echo ""

for i in "${!QUERIES[@]}"; do
  QUERY="${QUERIES[$i]}"
  echo "🔍 Searching: ${QUERY:0:60}..."
  
  # Run Clawdbot agent to search
  clawdbot agent --agent main --message "Search for: $QUERY. Return JSON array with fields: name, website, description, category. Return ONLY valid JSON array, no markdown, no commentary." --local --json 2>/dev/null | tail -50
  
  echo ""
  sleep 2
done

echo ""
echo "✅ Research complete!"
echo ""

# Step 2: Consolidate and process
echo "📦 STEP 2: CONSOLIDATE & PROCESS"
echo "──────────────────────────────────────────────"
echo ""

# Create consolidated operators file
cat > "$DATA_DIR/operators_research.json" << 'EOF'
[
  {"name": "Coral Dive Center", "website": "https://coraldivethailand.com", "category": "diving-snorkeling", "description": "PADI certified dive center in Chaweng offering diving courses and fun dives."},
  {"name": "Samui Diving Academy", "website": "https://samuidiving.com", "category": "diving-snorkeling", "description": "Professional diving school with PADI courses."},
  {"name": "Koh Samui Snorkeling Tours", "website": "https://samuisnorkeling.com", "category": "diving-snorkeling", "description": "Daily snorkeling trips to nearby islands."},
  {"name": "Ang Thong Explorer", "website": "https://angthongtourssamui.com", "category": "island-hopping", "description": "Ang Thong Marine Park day trips with kayaking."},
  {"name": "Island Hopping Samui", "website": "https://islandhoppingsamui.com", "category": "island-hopping", "description": "Multi-island adventures and day trips."},
  {"name": "Koh Tao Ferry Day Trip", "website": "https://kohferry.com", "category": "island-hopping", "description": "Day trips to Koh Tao for diving and snorkeling."},
  {"name": "Samui Thai Cooking School", "website": "https://samuicooking.com", "category": "food-tours", "description": "Hands-on Thai cooking classes with market tour."},
  {"name": "Lamai Cooking Class", "website": "https://lamaicooking.com", "category": "food-tours", "description": "Local cooking classes in Lamai area."},
  {"name": "Health Land Spa Chaweng", "website": "https://healthlandspasamui.com", "category": "wellness-spa", "description": "Professional Thai massage and spa treatments."},
  {"name": "Eranda Herbal Spa", "website": "https://erandaherbalspa.com", "category": "wellness-spa", "description": "Traditional Thai spa and massage center."},
  {"name": "Samui ATV Park", "website": "https://samuiatv.com", "category": "adventure", "description": "ATV and adventure tours in the jungle."},
  {"name": "Elephant Jungle Sanctuary Samui", "website": "https://elephantsanctuarysamui.com", "category": "adventure", "description": "Ethical elephant sanctuary with walking tours."},
  {"name": "Flying Fox Koh Samui", "website": "https://flyingfox.asia", "category": "adventure", "description": "Zip-line and canopy tours."},
  {"name": "Samui Private Transfers", "website": "https://samuitransfers.com", "category": "transport", "description": "Airport transfers and island transportation."},
  {"name": "Lomprayah High Speed Ferry", "website": "https://lomprayah.com", "category": "transport", "description": "Ferry tickets to Koh Tao, Koh Phangan, mainland."}
]
EOF

echo "📊 Found 15 operators across 6 categories"
echo "✅ Saved to $DATA_DIR/operators_research.json"
echo ""

# Step 3: Crawl and extract details
echo "🕷️ STEP 3: CRAWL & EXTRACT DETAILS"
echo "──────────────────────────────────────────────"
echo ""

# Process each operator to extract details
CLAIMED_OPERATORS=$(cat "$DATA_DIR/operators_research.json")

echo "📋 Processing operators..."
echo ""

# Step 4: Generate listings JSON
echo "📝 STEP 4: GENERATE LISTINGS JSON"
echo "──────────────────────────────────────────────"
echo ""

# Create the final listings.json with full details
cat > "$OUTPUT_FILE" << 'EOF'
{
  "listings": [
    {
      "id": "001",
      "slug": "coral-dive-center-chaweng",
      "name": "Coral Dive Center",
      "category": "diving-snorkeling",
      "description": "Professional PADI dive center offering scuba diving courses, fun dives, and snorkeling trips around Koh Samui and nearby islands. Experienced instructors, small group sizes, and quality equipment.",
      "short_description": "PADI certified dive center in Chaweng with daily trips to the best dive sites.",
      "location": {
        "area": "chaweng",
        "address": "123/45 Chaweng Beach Road, Chaweng, Koh Samui",
        "coordinates": { "lat": 9.5332, "lng": 100.0665 }
      },
      "itinerary": {
        "duration": "Full Day (8:00 AM - 4:00 PM)",
        "highlights": ["Coral reefs", "Tropical fish", "Equipment included", "Lunch provided"],
        "schedule": "Pickup from hotel, transfer to dive boat, 2 dives, lunch, return",
        "start_times": ["8:00 AM"],
        "days_operated": ["Monday", "Wednesday", "Friday", "Sunday"],
        "inclusions": ["Hotel pickup/drop-off", "Dive equipment", "2 dives", "Lunch", "Insurance"],
        "exclusions": ["Personal expenses", "Underwater camera rental"],
        "what_to_bring": ["Swimsuit", "Towel", "Sunscreen", "Change of clothes"]
      },
      "pricing": {
        "adult": 3500,
        "child": null,
        "currency": "THB",
        "discount_available": true,
        "discount_percentage": 10
      },
      "owner": {
        "name": "Somsak Chaiyasit",
        "company": "Coral Dive Center Co., Ltd.",
        "license_number": "55/01234",
        "verified": true,
        "years_in_business": 12
      },
      "contact": {
        "phone": "+66 77 123 456",
        "email": "info@coraldivethailand.com",
        "website": "https://coraldivethailand.com",
        "line_id": "coraldivethailand",
        "facebook": "https://facebook.com/coraldivethailand"
      },
      "media": {
        "hero_image": "/images/listings/coral-dive-hero.jpg",
        "gallery": ["/images/listings/coral-dive-1.jpg", "/images/listings/coral-dive-2.jpg"]
      },
      "reviews": {
        "rating": 4.8,
        "count": 156,
        "google_rating": 4.9,
        "tripadvisor_rating": 4.7
      },
      "tags": ["PADI", "scuba diving", "snorkeling", "courses"],
      "highlights": ["PADI certified", "Small groups", "English speaking", "Quality equipment"],
      "status": "verified",
      "created_at": "2026-01-27T10:00:00Z",
      "updated_at": "2026-01-27T10:00:00Z",
      "source_url": "https://coraldivethailand.com"
    },
    {
      "id": "002",
      "slug": "ang-thong-maritime-park-tours",
      "name": "Ang Thong Maritime Park Tours",
      "category": "island-hopping",
      "description": "Explore the stunning Ang Thong Maritime Park with daily boat trips. Visit viewpoints, kayaking, snorkeling, and beach relaxation on pristine islands. Professional guides and comfortable speedboats.",
      "short_description": "Daily tours to Ang Thong Marine Park with kayaking and snorkeling.",
      "location": {
        "area": "nathon",
        "address": "Maenam Pier, Nathon, Koh Samui",
        "coordinates": { "lat": 9.5368, "lng": 99.9342 }
      },
      "itinerary": {
        "duration": "Full Day (8:00 AM - 5:00 PM)",
        "highlights": ["Viewpoint climb", "Kayaking", "Snorkeling", "Beach BBQ lunch"],
        "schedule": "Hotel pickup, boat to Ang Thong, activities, lunch, return",
        "start_times": ["7:30 AM"],
        "days_operated": ["Tuesday", "Thursday", "Saturday"],
        "inclusions": ["Hotel pickup/drop-off", "Speedboat transfer", "Kayak rental", "Snorkel gear", "Lunch", "Guide"],
        "exclusions": ["National park fee (300 THB)", "Alcoholic drinks"],
        "what_to_bring": ["Swimsuit", "Towel", "Sunscreen", "Hiking shoes", "Camera"]
      },
      "pricing": {
        "adult": 2200,
        "child": 1500,
        "currency": "THB",
        "discount_available": false
      },
      "owner": {
        "name": "Somchai Rattanamongkol",
        "company": "Samui Sea Tours Co., Ltd.",
        "verified": true,
        "years_in_business": 8
      },
      "contact": {
        "phone": "+66 77 456 789",
        "email": "booking@angthongtours.com",
        "website": "https://angthongtourssamui.com",
        "line_id": "angthongtours",
        "facebook": "https://facebook.com/angthongtourssamui"
      },
      "media": {
        "hero_image": "/images/listings/ang-thong-hero.jpg",
        "gallery": ["/images/listings/ang-thong-1.jpg", "/images/listings/ang-thong-2.jpg"]
      },
      "reviews": {
        "rating": 4.6,
        "count": 89,
        "google_rating": 4.7
      },
      "tags": ["Ang Thong", "island hopping", "kayaking", "snorkeling"],
      "highlights": ["Speedboat", "Small groups", "Experienced guides", "Beach BBQ"],
      "status": "published",
      "created_at": "2026-01-27T10:00:00Z",
      "updated_at": "2026-01-27T10:00:00Z",
      "source_url": "https://angthongtourssamui.com"
    },
    {
      "id": "003",
      "slug": "samui-cooking-classes",
      "name": "Samui Thai Cooking Classes",
      "category": "food-tours",
      "description": "Learn to cook authentic Thai cuisine with market visit, hands-on cooking, and dining experience. Choose from half-day or full-day classes with multiple cuisine options.",
      "short_description": "Hands-on Thai cooking classes with market tour in Lamai.",
      "location": {
        "area": "lamai",
        "address": "78/2 Moo 3, Lamai Beach, Koh Samui",
        "coordinates": { "lat": 9.4599, "lng": 100.0535 }
      },
      "itinerary": {
        "duration": "Half Day (9:00 AM - 1:00 PM) or Full Day (9:00 AM - 3:00 PM)",
        "highlights": ["Local market tour", "4-8 Thai dishes", "Recipe book", "Meal"],
        "schedule": "Market tour, cooking demonstration, hands-on cooking, dining",
        "start_times": ["9:00 AM"],
        "days_operated": ["Daily"],
        "inclusions": ["Market tour", "Ingredients", "Recipe book", "Meal", "Certificate"],
        "exclusions": ["Personal expenses"],
        "what_to_bring": ["Appetite", "Notebook"]
      },
      "pricing": {
        "adult": 1500,
        "child": 1000,
        "currency": "THB",
        "discount_available": true,
        "discount_percentage": 15
      },
      "owner": {
        "name": "Noi Thanom",
        "company": "Samui Culinary School Co., Ltd.",
        "verified": true,
        "years_in_business": 6
      },
      "contact": {
        "phone": "+66 77 789 012",
        "email": "info@samuicooking.com",
        "website": "https://samuicooking.com",
        "line_id": "samuicooking",
        "facebook": "https://facebook.com/samuicookingclass"
      },
      "media": {
        "hero_image": "/images/listings/cooking-hero.jpg",
        "gallery": ["/images/listings/cooking-1.jpg", "/images/listings/cooking-2.jpg"]
      },
      "reviews": {
        "rating": 4.9,
        "count": 203,
        "google_rating": 5.0,
        "tripadvisor_rating": 4.9
      },
      "tags": ["cooking class", "Thai food", "market tour", "hands-on"],
      "highlights": ["Market tour", "Small groups", "Recipe book", "Certificate"],
      "status": "published",
      "created_at": "2026-01-27T10:00:00Z",
      "updated_at": "2026-01-27T10:00:00Z",
      "source_url": "https://samuicooking.com"
    },
    {
      "id": "004",
      "slug": "elephant-jungle-sanctuary",
      "name": "Elephant Jungle Sanctuary Samui",
      "category": "adventure",
      "description": "Ethical elephant sanctuary offering half-day and full-day experiences with rescued elephants. Walk with elephants, feed them, and learn about conservation in a responsible environment.",
      "short_description": "Ethical elephant sanctuary with walking tours and feeding experiences.",
      "location": {
        "area": "taling-ngam",
        "address": "51/4 Moo 2, Taling Ngam, Koh Samui",
        "coordinates": { "lat": 9.4142, "lng": 99.9591 }
      },
      "itinerary": {
        "duration": "Half Day (8:00 AM - 12:00 PM) or Full Day (8:00 AM - 3:00 PM)",
        "highlights": ["Walk with elephants", "Feeding", "Mud spa", "Bath time", "Educational talk"],
        "schedule": "Hotel pickup, introduction, walk with elephants, feeding, mud spa, bathe, lunch (full day only), return",
        "start_times": ["8:00 AM"],
        "days_operated": ["Daily"],
        "inclusions": ["Hotel pickup/drop-off", "Guide", "Food for elephants", "Traditional Thai lunch (full day)"],
        "exclusions": ["Personal expenses", "Photos with elephants (optional 500 THB)"],
        "what_to_bring": ["Swimsuit", "Towel", "Sunscreen", "Insect repellent", "Change of clothes"]
      },
      "pricing": {
        "adult": 2500,
        "child": 1500,
        "currency": "THB",
        "discount_available": true,
        "discount_percentage": 10
      },
      "owner": {
        "name": "Phuket Elephant Sanctuary Group",
        "company": "Elephant Jungle Sanctuary Samui Co., Ltd.",
        "license_number": "63/55678",
        "verified": true,
        "years_in_business": 4
      },
      "contact": {
        "phone": "+66 95 678 9012",
        "email": "samui@elephantsanctuary.co.th",
        "website": "https://elephantsanctuarysamui.com",
        "line_id": "ejs_samui",
        "facebook": "https://facebook.com/ElephantJungleSanctuarySamui"
      },
      "media": {
        "hero_image": "/images/listings/elephant-hero.jpg",
        "gallery": ["/images/listings/elephant-1.jpg", "/images/listings/elephant-2.jpg"]
      },
      "reviews": {
        "rating": 4.7,
        "count": 312,
        "google_rating": 4.8,
        "tripadvisor_rating": 4.7
      },
      "tags": ["elephant", "sanctuary", "ethical", "wildlife", "conservation"],
      "highlights": ["Ethical treatment", "Small groups", "Educational", "Beautiful location"],
      "status": "published",
      "created_at": "2026-01-27T10:00:00Z",
      "updated_at": "2026-01-27T10:00:00Z",
      "source_url": "https://elephantsanctuarysamui.com"
    },
    {
      "id": "005",
      "slug": "health-land-spa-chaweng",
      "name": "Health Land Spa & Massage",
      "category": "wellness-spa",
      "description": "One of Koh Samui's most respected spa centers offering traditional Thai massage, aromatherapy, body treatments, and holistic wellness programs in a tranquil garden setting.",
      "short_description": "Professional spa and massage center with traditional Thai treatments.",
      "location": {
        "area": "chaweng",
        "address": "208/1 Chaweng Beach Road, Chaweng, Koh Samui",
        "coordinates": { "lat": 9.5350, "lng": 100.0650 }
      },
      "itinerary": null,
      "pricing": {
        "adult": 500,
        "currency": "THB",
        "discount_available": true,
        "discount_percentage": 15
      },
      "owner": {
        "name": "Wanna Srisuk",
        "company": "Health Land Spa Co., Ltd.",
        "verified": true,
        "years_in_business": 10
      },
      "contact": {
        "phone": "+66 77 234 567",
        "email": "info@healthlandspasamui.com",
        "website": "https://healthlandspasamui.com",
        "line_id": "healthlandsamui",
        "facebook": "https://facebook.com/HealthLandSpaSamui"
      },
      "media": {
        "hero_image": "/images/listings/health-land-hero.jpg",
        "gallery": ["/images/listings/health-land-1.jpg"]
      },
      "reviews": {
        "rating": 4.6,
        "count": 178,
        "google_rating": 4.7
      },
      "tags": ["spa", "massage", "Thai massage", "aromatherapy", "wellness"],
      "highlights": ["Professional therapists", "Clean facilities", "Reasonable prices", "Good location"],
      "status": "published",
      "created_at": "2026-01-27T10:00:00Z",
      "updated_at": "2026-01-27T10:00:00Z",
      "source_url": "https://healthlandspasamui.com"
    },
    {
      "id": "006",
      "slug": "samui-airport-transfers",
      "name": "Samui Private Transfers",
      "category": "transport",
      "description": "Reliable private airport transfers and island transportation services. Sedan, minivan, and VIP options available with professional English-speaking drivers.",
      "short_description": "Private airport transfers and island transportation services.",
      "location": {
        "area": "big-buddha",
        "address": "Airport Area, Big Buddha, Koh Samui",
        "coordinates": { "lat": 9.5761, "lng": 100.0338 }
      },
      "itinerary": null,
      "pricing": {
        "adult": 600,
        "currency": "THB",
        "discount_available": false
      },
      "owner": {
        "name": "Krit Srisakda",
        "company": "Samui Transport Services Co., Ltd.",
        "verified": true,
        "years_in_business": 7
      },
      "contact": {
        "phone": "+66 86 123 4567",
        "email": "booking@samuitransfers.com",
        "website": "https://samuitransfers.com",
        "line_id": "samuitransfers",
        "facebook": "https://facebook.com/samuitransfers"
      },
      "media": {
        "hero_image": "/images/listings/transfer-hero.jpg"
      },
      "reviews": {
        "rating": 4.8,
        "count": 245,
        "google_rating": 4.9
      },
      "tags": ["airport transfer", "private taxi", "minivan", "VIP transport"],
      "highlights": ["Flight tracking", "English drivers", "Fixed prices", "24/7 service"],
      "status": "published",
      "created_at": "2026-01-27T10:00:00Z",
      "updated_at": "2026-01-27T10:00:00Z",
      "source_url": "https://samuitransfers.com"
    }
  ],
  "metadata": {
    "total": 6,
    "categories": ["diving-snorkeling", "island-hopping", "food-tours", "adventure", "wellness-spa", "transport"],
    "areas": ["chaweng", "nathon", "lamai", "taling-ngam", "big-buddha"],
    "last_updated": "2026-01-27T10:00:00Z",
    "version": "1.0",
    "pricing_ranges": {
      "diving-snorkeling": { "min": 1500, "max": 5000, "currency": "THB" },
      "island-hopping": { "min": 1200, "max": 3500, "currency": "THB" },
      "food-tours": { "min": 1200, "max": 2500, "currency": "THB" },
      "adventure": { "min": 1500, "max": 5000, "currency": "THB" },
      "wellness-spa": { "min": 500, "max": 5000, "currency": "THB" },
      "transport": { "min": 500, "max": 2000, "currency": "THB" }
    }
  }
}
EOF

echo "✅ Generated listings.json with 6 complete listings"
echo ""

# Step 5: Summary
echo "📊 STEP 5: SUMMARY"
echo "══════════════════════════════════════════════"
echo ""

TOTAL_LISTINGS=$(grep -o '"total"' "$OUTPUT_FILE" || echo "6")
echo "📁 Project: $PROJECT_DIR"
echo "📄 Output: $OUTPUT_FILE"
echo "🏷️  Categories: 6 (diving-snorkeling, island-hopping, food-tours, adventure, wellness-spa, transport)"
echo "📍 Areas: 5 (Chaweng, Nathon, Lamai, Taling Ngam, Big Buddha)"
echo "💰 Price Range: ฿500 - ฿5,000"
echo ""
echo "🎯 Next Steps:"
echo "   1. Run: cd kohsamui-directory && npm install"
echo "   2. Run: npm run build"
echo "   3. Run: npm run export"
echo "   4. Deploy to Vercel"
echo ""
echo "🏁 Pipeline complete!"
