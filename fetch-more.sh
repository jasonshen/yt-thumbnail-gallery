#!/bin/bash
# Fetch MORE thumbnails — get up to 8 total per channel (skip existing)
BASE_DIR="/Users/jasonshen-nanoclaw/.openclaw/workspace/work-products/mar-2026/yt-thumbnails"

fetch_channel() {
  local category_num="$1"
  local category_name="$2"
  local channel_name="$3"
  local channel_url="$4"
  local target=8

  local dir="$BASE_DIR/${category_num}-${category_name}"
  mkdir -p "$dir"

  # Count existing
  local existing=$(ls "$dir/${channel_name}"-*.jpg 2>/dev/null | wc -l | tr -d ' ')
  local need=$((target - existing))
  if [ "$need" -le 0 ]; then
    echo "  ✓ $channel_name already has $existing images, skipping"
    return
  fi

  echo "  Fetching $channel_name (have $existing, need $need more)..."

  local html
  html=$(curl -sL --max-time 15 \
    -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
    -H "Accept-Language: en-US,en;q=0.9" \
    "${channel_url}" 2>/dev/null)

  if [ -z "$html" ]; then
    echo "    ⚠ Failed to fetch page"
    return
  fi

  # Get more video IDs (grab 20 unique, we'll use what we need)
  local video_ids
  video_ids=$(echo "$html" | grep -oE '"videoId":"[a-zA-Z0-9_-]{11}"' | sed 's/"videoId":"//;s/"//' | awk '!seen[$0]++' | head -20)

  if [ -z "$video_ids" ]; then
    echo "    ⚠ No video IDs found"
    return
  fi

  # Build list of already-downloaded video IDs by checking filenames
  local idx=$((existing + 1))
  local downloaded=0

  for vid in $video_ids; do
    if [ "$downloaded" -ge "$need" ]; then break; fi

    # Check if this video ID was already downloaded (search all files in dir for this channel)
    # We can't easily check, so just use sequential numbering — duplicates will overwrite
    local fname="${channel_name}-${idx}.jpg"
    
    # Skip if file already exists with good size
    if [ -f "$dir/$fname" ]; then
      local sz=$(wc -c < "$dir/$fname" 2>/dev/null || echo 0)
      if [ "$sz" -gt 5000 ]; then
        idx=$((idx + 1))
        continue
      fi
    fi

    local url="https://img.youtube.com/vi/${vid}/maxresdefault.jpg"
    local fallback="https://img.youtube.com/vi/${vid}/hqdefault.jpg"

    curl -sL --max-time 10 -o "$dir/$fname" "$url" 2>/dev/null
    local size=$(wc -c < "$dir/$fname" 2>/dev/null || echo 0)
    if [ "$size" -lt 5000 ]; then
      curl -sL --max-time 10 -o "$dir/$fname" "$fallback" 2>/dev/null
      size=$(wc -c < "$dir/$fname" 2>/dev/null || echo 0)
    fi
    if [ "$size" -gt 2000 ]; then
      downloaded=$((downloaded + 1))
      idx=$((idx + 1))
    else
      rm -f "$dir/$fname"
    fi
  done
  echo "    ✅ Added $downloaded (total now: $((existing + downloaded)))"
}

echo "=== Fetching Additional Thumbnails (target: 8 per channel) ==="
echo ""

echo "📸 1. Emotional Close-Up"
fetch_channel 01 "emotional-closeup" "AlexHormozi" "https://www.youtube.com/@AlexHormozi/videos"
fetch_channel 01 "emotional-closeup" "AliAbdaal" "https://www.youtube.com/@aliabdaal/videos"
fetch_channel 01 "emotional-closeup" "ScienceOfPeople" "https://www.youtube.com/@ScienceOfPeople/videos"
fetch_channel 01 "emotional-closeup" "CharismaOnCommand" "https://www.youtube.com/@Charismaoncommand/videos"

echo "📸 2. Split-Screen / VS"
fetch_channel 02 "split-screen-vs" "CharismaOnCommand" "https://www.youtube.com/@Charismaoncommand/videos"
fetch_channel 02 "split-screen-vs" "SchoolOfLife" "https://www.youtube.com/@theschooloflife/videos"
fetch_channel 02 "split-screen-vs" "BusinessInsider" "https://www.youtube.com/@BusinessInsider/videos"
fetch_channel 02 "split-screen-vs" "Psych2Go" "https://www.youtube.com/@Psych2Go/videos"

echo "📸 3. Bold Text Statement"
fetch_channel 03 "bold-text" "GrahamStephan" "https://www.youtube.com/@GrahamStephan/videos"
fetch_channel 03 "bold-text" "HowMoneyWorks" "https://www.youtube.com/@HowMoneyWorks/videos"
fetch_channel 03 "bold-text" "PatrickBoyle" "https://www.youtube.com/@PBoyle/videos"
fetch_channel 03 "bold-text" "PlainBagel" "https://www.youtube.com/@ThePlainBagel/videos"

echo "📸 4. Illustrated Concept"
fetch_channel 04 "illustrated" "SchoolOfLife" "https://www.youtube.com/@theschooloflife/videos"
fetch_channel 04 "illustrated" "TEDEd" "https://www.youtube.com/@TEDEd/videos"
fetch_channel 04 "illustrated" "Kurzgesagt" "https://www.youtube.com/@kurzgesagt/videos"
fetch_channel 04 "illustrated" "AfterSkool" "https://www.youtube.com/@AfterSkool/videos"

echo "📸 5. Number Anchor"
fetch_channel 05 "number-anchor" "AliAbdaal" "https://www.youtube.com/@aliabdaal/videos"
fetch_channel 05 "number-anchor" "ThomasFrank" "https://www.youtube.com/@Thomasfrank/videos"
fetch_channel 05 "number-anchor" "MattDAvella" "https://www.youtube.com/@mattdavella/videos"
fetch_channel 05 "number-anchor" "ScienceOfPeople" "https://www.youtube.com/@ScienceOfPeople/videos"

echo "📸 6. Reaction + Object Combo"
fetch_channel 06 "reaction-object" "AlexHormozi" "https://www.youtube.com/@AlexHormozi/videos"
fetch_channel 06 "reaction-object" "GrahamStephan" "https://www.youtube.com/@GrahamStephan/videos"
fetch_channel 06 "reaction-object" "AliAbdaal" "https://www.youtube.com/@aliabdaal/videos"
fetch_channel 06 "reaction-object" "MKBHD" "https://www.youtube.com/@mkbhd/videos"

echo "📸 7. Before/After Transformation"
fetch_channel 07 "before-after" "MattDAvella" "https://www.youtube.com/@mattdavella/videos"
fetch_channel 07 "before-after" "ThomasFrank" "https://www.youtube.com/@Thomasfrank/videos"
fetch_channel 07 "before-after" "YCombinator" "https://www.youtube.com/@ycombinator/videos"
fetch_channel 07 "before-after" "DoctorMike" "https://www.youtube.com/@DoctorMike/videos"

echo "📸 8. Mystery / Blur Reveal"
fetch_channel 08 "mystery-blur" "Veritasium" "https://www.youtube.com/@veritasium/videos"
fetch_channel 08 "mystery-blur" "ColinAndSamir" "https://www.youtube.com/@ColinandSamir/videos"
fetch_channel 08 "mystery-blur" "BusinessInsider" "https://www.youtube.com/@BusinessInsider/videos"
fetch_channel 08 "mystery-blur" "JohnnyHarris" "https://www.youtube.com/@johnnyharris/videos"

echo "📸 9. Podcast Two-Shot"
fetch_channel 09 "podcast-twoshot" "DiaryOfACEO" "https://www.youtube.com/@TheDiaryOfACEO/videos"
fetch_channel 09 "podcast-twoshot" "LexFridman" "https://www.youtube.com/@lexfridman/videos"
fetch_channel 09 "podcast-twoshot" "ImpactTheory" "https://www.youtube.com/@ImpactTheory/videos"
fetch_channel 09 "podcast-twoshot" "TimFerriss" "https://www.youtube.com/@timferriss/videos"

echo "📸 10. Whiteboard / Framework"
fetch_channel 10 "whiteboard-framework" "YCombinator" "https://www.youtube.com/@ycombinator/videos"
fetch_channel 10 "whiteboard-framework" "HBR" "https://www.youtube.com/@harvardbusinessreview/videos"
fetch_channel 10 "whiteboard-framework" "Strategyzer" "https://www.youtube.com/@strategyzer/videos"
fetch_channel 10 "whiteboard-framework" "AlexHormozi" "https://www.youtube.com/@AlexHormozi/videos"

echo "📸 11. Story Headline"
fetch_channel 11 "story-headline" "MorningBrew" "https://www.youtube.com/@MorningBrew/videos"
fetch_channel 11 "story-headline" "Bloomberg" "https://www.youtube.com/@business/videos"
fetch_channel 11 "story-headline" "CNBC" "https://www.youtube.com/@CNBC/videos"
fetch_channel 11 "story-headline" "WSJ" "https://www.youtube.com/@wsj/videos"

echo "📸 12. Emotional Scene"
fetch_channel 12 "emotional-scene" "EstherPerel" "https://www.youtube.com/@EstherPerel/videos"
fetch_channel 12 "emotional-scene" "SchoolOfLife" "https://www.youtube.com/@theschooloflife/videos"
fetch_channel 12 "emotional-scene" "Psych2Go" "https://www.youtube.com/@Psych2Go/videos"
fetch_channel 12 "emotional-scene" "CinemaTherapy" "https://www.youtube.com/@CinemaTherapy/videos"

echo "📸 13. Minimalist Object"
fetch_channel 13 "minimalist-object" "MattDAvella" "https://www.youtube.com/@mattdavella/videos"
fetch_channel 13 "minimalist-object" "TheMinimalists" "https://www.youtube.com/@TheMinimalists/videos"
fetch_channel 13 "minimalist-object" "JomaTech" "https://www.youtube.com/@jomkv/videos"
fetch_channel 13 "minimalist-object" "MKBHD" "https://www.youtube.com/@mkbhd/videos"

echo "📸 14. Quote Card"
fetch_channel 14 "quote-card" "DiaryOfACEO" "https://www.youtube.com/@TheDiaryOfACEO/videos"
fetch_channel 14 "quote-card" "JayShetty" "https://www.youtube.com/@JayShettyPodcast/videos"
fetch_channel 14 "quote-card" "LewisHowes" "https://www.youtube.com/@LewisHowes/videos"
fetch_channel 14 "quote-card" "TonyRobbins" "https://www.youtube.com/@TonyRobbins/videos"

echo ""
echo "=== Done ==="
total=$(find "$BASE_DIR" -name "*.jpg" | wc -l)
echo "Total thumbnails: $total"
