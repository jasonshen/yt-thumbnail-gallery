#!/bin/bash
# Fetch YouTube thumbnails organized by thumbnail format category
# Usage: bash fetch-thumbnails.sh

BASE_DIR="/Users/jasonshen-nanoclaw/.openclaw/workspace/work-products/mar-2026/yt-thumbnails"
mkdir -p "$BASE_DIR"

fetch_channel() {
  local category_num="$1"
  local category_name="$2"
  local channel_name="$3"
  local channel_url="$4"
  local count="${5:-3}"  # default 3 thumbnails per channel

  local dir="$BASE_DIR/${category_num}-${category_name}"
  mkdir -p "$dir"

  echo "  Fetching $channel_name ($channel_url)..."

  # Get the channel videos page HTML and extract video IDs
  local html
  html=$(curl -sL --max-time 15 \
    -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
    -H "Accept-Language: en-US,en;q=0.9" \
    "${channel_url}" 2>/dev/null)

  if [ -z "$html" ]; then
    echo "    ⚠ Failed to fetch page"
    return
  fi

  # Extract video IDs from the page (they appear in various patterns)
  local video_ids
  video_ids=$(echo "$html" | grep -oE '"videoId":"[a-zA-Z0-9_-]{11}"' | head -20 | sed 's/"videoId":"//;s/"//' | sort -u | head -"$count")

  if [ -z "$video_ids" ]; then
    echo "    ⚠ No video IDs found"
    return
  fi

  local idx=1
  for vid in $video_ids; do
    local fname="${channel_name}-${idx}.jpg"
    # Try maxresdefault first, fall back to hqdefault
    local url="https://img.youtube.com/vi/${vid}/maxresdefault.jpg"
    local fallback="https://img.youtube.com/vi/${vid}/hqdefault.jpg"

    curl -sL --max-time 10 -o "$dir/$fname" "$url" 2>/dev/null
    # Check if we got a real image (maxresdefault returns a small placeholder if unavailable)
    local size=$(wc -c < "$dir/$fname" 2>/dev/null || echo 0)
    if [ "$size" -lt 5000 ]; then
      curl -sL --max-time 10 -o "$dir/$fname" "$fallback" 2>/dev/null
    fi
    size=$(wc -c < "$dir/$fname" 2>/dev/null || echo 0)
    if [ "$size" -gt 2000 ]; then
      echo "    ✅ $fname (${size} bytes)"
    else
      rm -f "$dir/$fname"
      echo "    ❌ $fname failed"
    fi
    idx=$((idx + 1))
  done
}

echo "=== Fetching YouTube Thumbnails ==="
echo ""

# 1. Emotional Close-Up
echo "📸 1. Emotional Close-Up"
fetch_channel 01 "emotional-closeup" "AlexHormozi" "https://www.youtube.com/@AlexHormozi/videos"
fetch_channel 01 "emotional-closeup" "AliAbdaal" "https://www.youtube.com/@aliabdaal/videos"
fetch_channel 01 "emotional-closeup" "ScienceOfPeople" "https://www.youtube.com/@ScienceOfPeople/videos"
fetch_channel 01 "emotional-closeup" "CharismaOnCommand" "https://www.youtube.com/@Charismaoncommand/videos"

# 2. Split-Screen / VS
echo "📸 2. Split-Screen / VS"
fetch_channel 02 "split-screen-vs" "CharismaOnCommand" "https://www.youtube.com/@Charismaoncommand/videos"
fetch_channel 02 "split-screen-vs" "SchoolOfLife" "https://www.youtube.com/@theschooloflife/videos"
fetch_channel 02 "split-screen-vs" "BusinessInsider" "https://www.youtube.com/@BusinessInsider/videos"
fetch_channel 02 "split-screen-vs" "Psych2Go" "https://www.youtube.com/@Psych2Go/videos"

# 3. Bold Text Statement
echo "📸 3. Bold Text Statement"
fetch_channel 03 "bold-text" "GrahamStephan" "https://www.youtube.com/@GrahamStephan/videos"
fetch_channel 03 "bold-text" "HowMoneyWorks" "https://www.youtube.com/@HowMoneyWorks/videos"
fetch_channel 03 "bold-text" "PatrickBoyle" "https://www.youtube.com/@PBoyle/videos"
fetch_channel 03 "bold-text" "PlainBagel" "https://www.youtube.com/@ThePlainBagel/videos"

# 4. Illustrated Concept
echo "📸 4. Illustrated Concept"
fetch_channel 04 "illustrated" "SchoolOfLife" "https://www.youtube.com/@theschooloflife/videos"
fetch_channel 04 "illustrated" "TEDEd" "https://www.youtube.com/@TEDEd/videos"
fetch_channel 04 "illustrated" "Kurzgesagt" "https://www.youtube.com/@kurzgesagt/videos"
fetch_channel 04 "illustrated" "AfterSkool" "https://www.youtube.com/@AfterSkool/videos"

# 5. Number Anchor
echo "📸 5. Number Anchor"
fetch_channel 05 "number-anchor" "AliAbdaal" "https://www.youtube.com/@aliabdaal/videos"
fetch_channel 05 "number-anchor" "ThomasFrank" "https://www.youtube.com/@Thomasfrank/videos"
fetch_channel 05 "number-anchor" "MattDAvella" "https://www.youtube.com/@mattdavella/videos"
fetch_channel 05 "number-anchor" "ScienceOfPeople" "https://www.youtube.com/@ScienceOfPeople/videos"

# 6. Reaction + Object Combo
echo "📸 6. Reaction + Object Combo"
fetch_channel 06 "reaction-object" "AlexHormozi" "https://www.youtube.com/@AlexHormozi/videos"
fetch_channel 06 "reaction-object" "GrahamStephan" "https://www.youtube.com/@GrahamStephan/videos"
fetch_channel 06 "reaction-object" "AliAbdaal" "https://www.youtube.com/@aliabdaal/videos"
fetch_channel 06 "reaction-object" "MKBHD" "https://www.youtube.com/@mkbhd/videos"

# 7. Before/After Transformation
echo "📸 7. Before/After Transformation"
fetch_channel 07 "before-after" "MattDAvella" "https://www.youtube.com/@mattdavella/videos"
fetch_channel 07 "before-after" "ThomasFrank" "https://www.youtube.com/@Thomasfrank/videos"
fetch_channel 07 "before-after" "YCombinator" "https://www.youtube.com/@ycombinator/videos"
fetch_channel 07 "before-after" "DoctorMike" "https://www.youtube.com/@DoctorMike/videos"

# 8. Mystery / Blur Reveal
echo "📸 8. Mystery / Blur Reveal"
fetch_channel 08 "mystery-blur" "Veritasium" "https://www.youtube.com/@veritasium/videos"
fetch_channel 08 "mystery-blur" "ColinAndSamir" "https://www.youtube.com/@ColinandSamir/videos"
fetch_channel 08 "mystery-blur" "BusinessInsider" "https://www.youtube.com/@BusinessInsider/videos"
fetch_channel 08 "mystery-blur" "JohnnyHarris" "https://www.youtube.com/@johnnyharris/videos"

# 9. Podcast / Interview Two-Shot
echo "📸 9. Podcast Two-Shot"
fetch_channel 09 "podcast-twoshot" "DiaryOfACEO" "https://www.youtube.com/@TheDiaryOfACEO/videos"
fetch_channel 09 "podcast-twoshot" "LexFridman" "https://www.youtube.com/@lexfridman/videos"
fetch_channel 09 "podcast-twoshot" "ImpactTheory" "https://www.youtube.com/@ImpactTheory/videos"
fetch_channel 09 "podcast-twoshot" "TimFerriss" "https://www.youtube.com/@timferriss/videos"

# 10. Whiteboard / Framework
echo "📸 10. Whiteboard / Framework"
fetch_channel 10 "whiteboard-framework" "YCombinator" "https://www.youtube.com/@ycombinator/videos"
fetch_channel 10 "whiteboard-framework" "HBR" "https://www.youtube.com/@harvardbusinessreview/videos"
fetch_channel 10 "whiteboard-framework" "Strategyzer" "https://www.youtube.com/@strategyzer/videos"
fetch_channel 10 "whiteboard-framework" "AlexHormozi" "https://www.youtube.com/@AlexHormozi/videos"

# 11. Story Headline
echo "📸 11. Story Headline"
fetch_channel 11 "story-headline" "MorningBrew" "https://www.youtube.com/@MorningBrew/videos"
fetch_channel 11 "story-headline" "Bloomberg" "https://www.youtube.com/@business/videos"
fetch_channel 11 "story-headline" "CNBC" "https://www.youtube.com/@CNBC/videos"
fetch_channel 11 "story-headline" "WSJ" "https://www.youtube.com/@wsj/videos"

# 12. Emotional Scene / Staged Moment
echo "📸 12. Emotional Scene"
fetch_channel 12 "emotional-scene" "EstherPerel" "https://www.youtube.com/@EstherPerel/videos"
fetch_channel 12 "emotional-scene" "SchoolOfLife" "https://www.youtube.com/@theschooloflife/videos"
fetch_channel 12 "emotional-scene" "Psych2Go" "https://www.youtube.com/@Psych2Go/videos"
fetch_channel 12 "emotional-scene" "CinemaTherapy" "https://www.youtube.com/@CinemaTherapy/videos"

# 13. Minimalist Object
echo "📸 13. Minimalist Object"
fetch_channel 13 "minimalist-object" "MattDAvella" "https://www.youtube.com/@mattdavella/videos"
fetch_channel 13 "minimalist-object" "TheMinimalists" "https://www.youtube.com/@TheMinimalists/videos"
fetch_channel 13 "minimalist-object" "JomaTech" "https://www.youtube.com/@jomkv/videos"
fetch_channel 13 "minimalist-object" "MKBHD" "https://www.youtube.com/@mkbhd/videos"

# 14. Quote Card / Pull Quote
echo "📸 14. Quote Card"
fetch_channel 14 "quote-card" "DiaryOfACEO" "https://www.youtube.com/@TheDiaryOfACEO/videos"
fetch_channel 14 "quote-card" "JayShetty" "https://www.youtube.com/@JayShettyPodcast/videos"
fetch_channel 14 "quote-card" "LewisHowes" "https://www.youtube.com/@LewisHowes/videos"
fetch_channel 14 "quote-card" "TonyRobbins" "https://www.youtube.com/@TonyRobbins/videos"

echo ""
echo "=== Done ==="
echo ""
# Summary
total=$(find "$BASE_DIR" -name "*.jpg" | wc -l)
echo "Total thumbnails downloaded: $total"
echo ""
for dir in "$BASE_DIR"/*/; do
  count=$(find "$dir" -name "*.jpg" 2>/dev/null | wc -l)
  echo "  $(basename "$dir"): $count images"
done
