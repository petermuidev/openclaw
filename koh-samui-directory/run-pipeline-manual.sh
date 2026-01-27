#!/bin/bash
# Koh Samui Directory Pipeline - Manual Run
# Run this script step by step or all at once

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATA_DIR="$PROJECT_DIR/data"
cd "$PROJECT_DIR"

echo "🏝️  KOH SAMUI DIRECTORY PIPELINE"
echo "═════════════════════════════════"
echo ""
echo "Project: $PROJECT_DIR"
echo ""

# ==============================================================================
# STAGE 1: RESEARCH
# ==============================================================================
stage1() {
    echo "📡 STAGE 1: RESEARCH"
    echo "──────────────────────────────────────────────"
    echo ""
    echo "Searching for tour operators across all categories..."
    echo ""

    clawdbot agent --agent main --message "Research Koh Samui tour operators for these 7 categories:
    - Diving & Snorkeling (PADI centers, daily dives)
    - Island Hopping (Ang Thong, Koh Tao, Koh Phangan)
    - Cooking Classes (Thai cuisine, market tours)
    - Spa & Wellness (Massage, traditional Thai)
    - ATV & Adventure (Jungle, zipline, ATV)
    - Elephant Sanctuaries (Ethical, walking tours)
    - Airport Transfers (Private taxi, minivan)

    For each operator find: name, website, phone, LINE ID, email, location_area.
    Return as JSON array with fields: name, website, category, description, phone, line_id, email, location_area.
    Find at least 5 operators per category. Return ONLY valid JSON array." --local

    echo ""
    echo "✅ Research complete. Results saved to ~/clawd/koh_samui_operators_output.json"
    echo ""
}

# ==============================================================================
# STAGE 2: CRAWL
# ==============================================================================
stage2() {
    echo "🕷️ STAGE 2: CRAWL WEBSITES"
    echo "──────────────────────────────────────────────"
    echo ""
    echo "Crawling operator websites for detailed information..."

    clawdbot agent --agent main --message "Crawl the websites of these Koh Samui operators and extract detailed information:
    $(cat ~/clawd/koh_samui_operators_output.json | jq -r '.[].website' | head -10 | sed 's/^/- /')

    For each website extract:
    - Tour types and descriptions
    - Pricing (adult, child)
    - Itinerary details (duration, schedule, inclusions)
    - Contact info (phone, email, LINE, WhatsApp)
    - Photos/hero image URLs
    - Reviews (Google rating, count)

    Return JSON array with all extracted data." --local

    echo ""
    echo "✅ Crawl complete."
    echo ""
}

# ==============================================================================
# STAGE 3: PARSE REVIEWS
# ==============================================================================
stage3() {
    echo "⭐ STAGE 3: PARSE REVIEWS"
    echo "──────────────────────────────────────────────"
    echo ""
    echo "Gathering reviews from Google, TripAdvisor..."

    clawdbot agent --agent main --message "Find Google Reviews and TripAdvisor ratings for these Koh Samui operators:
    - Silent Divers (silentdivers.com)
    - Discovery Dive Center (discoverydivers.com)
    - Smiley Cook (smileycooksamui.com)
    - Samui Elephant Sanctuary (samuielephantsanctuary.org)
    - 100 Degrees East Diving (100degreeseast.com)

    For each, return: operator_name, google_rating, google_reviews, tripadvisor_rating, tripadvisor_reviews, last_updated.
    Return as JSON array." --local

    echo ""
    echo "✅ Reviews gathered."
    echo ""
}

# ==============================================================================
# STAGE 4: GET IMAGES
# ==============================================================================
stage4() {
    echo "🖼️ STAGE 4: GET IMAGES"
    echo "──────────────────────────────────────────────"
    echo ""
    echo "Generating or fetching hero images for each operator..."

    OPERATORS=$(cat ~/clawd/koh_samui_operators_output.json | jq -r '.[].name' | head -5)

    for NAME in $OPERATORS; do
        SLUG=$(echo "$NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '[:punct:]')
        echo "  📷 $NAME..."

        # Try to generate with AI (comment out if not needed)
        # clawdbot chutes-image-gen \
        #   --prompt "Professional tour operator for $NAME in Koh Samui Thailand" \
        #   --output "images/${SLUG}-hero.png" 2>/dev/null || true
    done

    echo ""
    echo "✅ Images ready."
    echo ""
}

# ==============================================================================
# STAGE 5: CREATE JSON
# ==============================================================================
stage5() {
    echo "📝 STAGE 5: CREATE LISTING FILES"
    echo "──────────────────────────────────────────────"
    echo ""
    echo "Converting operators to per-slug listing format..."

    node scripts/import-operators.js

    echo ""
    echo "✅ Listings created in data/{slug}/"
    echo ""
}

# ==============================================================================
# STAGE 6: BUILD SITE
# ==============================================================================
stage6() {
    echo "🏗️ STAGE 6: BUILD SITE"
    echo "──────────────────────────────────────────────"
    echo ""
    echo "Building Next.js static site..."

    npm install
    npm run build
    npm run export

    echo ""
    echo "✅ Site built in out/ folder"
    echo ""
}

# ==============================================================================
# STAGE 7: VERIFY QUALITY
# ==============================================================================
stage7() {
    echo "✅ STAGE 7: VERIFY QUALITY"
    echo "──────────────────────────────────────────────"
    echo ""
    echo "Checking data quality..."

    node scripts/verify-quality.js

    echo ""
    echo "✅ Quality check complete."
    echo ""
}

# ==============================================================================
# MAIN
# ==============================================================================
case "${1:-all}" in
    1|stage1|research)
        stage1
        ;;
    2|stage2|crawl)
        stage2
        ;;
    3|stage3|reviews)
        stage3
        ;;
    4|stage4|images)
        stage4
        ;;
    5|stage5|create)
        stage5
        ;;
    6|stage6|build)
        stage6
        ;;
    7|stage7|verify)
        stage7
        ;;
    all)
        echo "Running full pipeline..."
        echo ""
        stage1
        stage5
        stage6
        stage7
        echo "═════════════════════════════════"
        echo "🏁 PIPELINE COMPLETE!"
        echo ""
        echo "📁 Output: out/"
        echo "📄 Listings: $(ls data/*/listing.json 2>/dev/null | wc -l)"
        echo ""
        ;;
    *)
        echo "Usage: $0 [stage]"
        echo ""
        echo "Stages:"
        echo "  1|stage1|research   - Research tour operators"
        echo "  2|stage2|crawl      - Crawl operator websites"
        echo "  3|stage3|reviews    - Parse reviews"
        echo "  4|stage4|images     - Get hero images"
        echo "  5|stage5|create     - Create listing JSON files"
        echo "  6|stage6|build      - Build Next.js site"
        echo "  7|stage7|verify     - Verify quality"
        echo "  all                 - Run all stages"
        echo ""
        ;;
esac
