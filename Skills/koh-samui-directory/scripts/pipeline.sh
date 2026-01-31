#!/bin/bash
# Koh Samui Directory Pipeline - Clawdbot Skill
# Creates: data/{slug}/listing.json for each listing

set -e

SKILL_DIR="$HOME/.clawd/koh-samui-directory"
DATA_DIR="$SKILL_DIR/data"
mkdir -p "$DATA_DIR"

echo "🏝️  KOH SAMUI DIRECTORY PIPELINE"
echo "═════════════════════════════════"
echo ""

CATEGORIES=("diving-snorkeling" "island-hopping" "food-tours" "wellness-spa" "adventure" "transport")

for CAT in "${CATEGORIES[@]}"; do
  echo "🔍 Researching: $CAT"

  QUERY="Koh Samui $CAT tour operators websites contact phone line"

  clawdbot agent --agent main --message "Research: $QUERY. For each operator found, create a JSON listing with: name, website, description, location_area, phone, line_id, email, facebook. Return an array of operator objects. Be thorough - find at least 5 operators per category." --local 2>/dev/null || true

  sleep 2
done

echo ""
echo "📦 STEP 2: CREATE LISTING FILES"
echo "────────────────────────────"

for CAT in "${CATEGORIES[@]}"; do
  echo "📂 Processing: $CAT"

  OPERATORS=$(cat "$SKILL_DIR/operators_$CAT.json" 2>/dev/null || echo "[]")

  if [ "$OPERATORS" != "[]" ] && [ -n "$OPERATORS" ]; then
    echo "$OPERATORS" | while read -r ITEM; do
      if [ -n "$ITEM" ]; then
        NAME=$(echo "$ITEM" | grep -o '"name":"[^"]*"' | head -1 | sed 's/"name":"//;s/"//g')
        WEBSITE=$(echo "$ITEM" | grep -o '"website":"[^"]*"' | head -1 | sed 's/"website":"//;s/"//g')
        DESC=$(echo "$ITEM" | grep -o '"description":"[^"]*"' | head -1 | sed 's/"description":"//;s/"//g')
        AREA=$(echo "$ITEM" | grep -o '"location_area":"[^"]*"' | head -1 | sed 's/"location_area":"//;s/"//g')
        PHONE=$(echo "$ITEM" | grep -o '"phone":"[^"]*"' | head -1 | sed 's/"phone":"//;s/"//g')
        LINE=$(echo "$ITEM" | grep -o '"line_id":"[^"]*"' | head -1 | sed 's/"line_id":"//;s/"//g')
        EMAIL=$(echo "$ITEM" | grep -o '"email":"[^"]*"' | head -1 | sed 's/"email":"//;s/"//g')
        FACEBOOK=$(echo "$ITEM" | grep -o '"facebook":"[^"]*"' | head -1 | sed 's/"facebook":"//;s/"//g')

        if [ -n "$NAME" ]; then
          SLUG=$(echo "$NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '[:punct:]' | tr -cd 'a-z0-9-')
          [ -n "$AREA" ] && SLUG="${SLUG}-${AREA}"

          LISTING_DIR="$DATA_DIR/$SLUG"
          mkdir -p "$LISTING_DIR"

          cat > "$LISTING_DIR/listing.json" << EOF
{
  "id": "$SLUG",
  "slug": "$SLUG",
  "name": "$NAME",
  "category": "$CAT",
  "description": "$DESC",
  "location": { "area": "$AREA" },
  "contact": {
    "phone": "$PHONE",
    "line": "$LINE",
    "email": "$EMAIL",
    "website": "$WEBSITE",
    "facebook": "$FACEBOOK"
  },
  "status": "draft"
}
EOF

          echo "  ✅ $SLUG/listing.json"
        fi
      fi
    done
  fi
done

echo ""
echo "📊 SUMMARY"
echo "═════════════════════════════════"
echo "📁 Output: $DATA_DIR/"
echo "🏷️  Categories: ${#CATEGORIES[@]}"
echo ""
echo "🎯 Next: Import into Next.js project"
