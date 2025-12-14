#!/usr/bin/env bash
# Waybar Weather Module Script
# Displays current weather and 3-day forecast
# Uses wttr.in API for weather data

set -euo pipefail

################################################################################
# CONFIGURATION
################################################################################

# City name (leave empty "" for IP-based auto-detection)
CITY="Leiden"

# Language code (ko=Korean, en=English, ja=Japanese, etc.)
# See: https://github.com/chubin/wttr.in#supported-languages
LANG="en"

# Metric units: m2 uses Celsius and m/s for wind
UNITS="m2"

# Tooltip labels (customize for your language)
LABEL_NOW="Now"
LABEL_TEMP="Temp"
LABEL_FEELS="Feels"
LABEL_WIND="Wind"
LABEL_RAIN="Rain"
LABEL_HUMIDITY="Humidity"
LABEL_PRESSURE="Pressure"

################################################################################
# SCRIPT - No need to modify below this line
################################################################################

# Get day names using system locale
day_num_today=$(date +'%u')
day_num_tomorrow=$(date -d tomorrow +'%u')
day_num_after=$(date -d '+2 days' +'%u')

get_day_name() {
    case $1 in
        1) date -d "monday" +'%A' ;;
        2) date -d "tuesday" +'%A' ;;
        3) date -d "wednesday" +'%A' ;;
        4) date -d "thursday" +'%A' ;;
        5) date -d "friday" +'%A' ;;
        6) date -d "saturday" +'%A' ;;
        7) date -d "sunday" +'%A' ;;
    esac
}

TODAY="$(get_day_name $day_num_today)"
TOMORROW="$(get_day_name $day_num_tomorrow)"
DAYAFTER="$(get_day_name $day_num_after)"

# Single curl call for all weather data
# Format: bar|location|condition|temp|feels|wind|rain|humidity|pressure|today|tomorrow|dayafter
weather_data="$(curl -4 -fsS "https://wttr.in/${CITY}?${UNITS}&lang=${LANG}&format=%c%t|%l|%C|%t|%f|%w|%p|%h|%P|%c+%t|{1%c+%t}|{2%c+%t}" 2>/dev/null || echo " --°C|Unknown|N/A|N/A|N/A|N/A|N/A|N/A|N/A|N/A|N/A|N/A")"

# Split the data
IFS='|' read -r bar location condition temp feels wind rain humidity pressure today tomorrow dayafter <<< "$weather_data"

# Clean up the forecast entries (remove leading numbers from {N...} format)
tomorrow="$(echo "$tomorrow" | sed 's/^[0-9]//g')"
dayafter="$(echo "$dayafter" | sed 's/^[0-9]//g')"

# Remove + signs from temperatures (keep only - for negatives)
bar="$(echo "$bar" | sed 's/+//g')"
temp="$(echo "$temp" | sed 's/+//g')"
feels="$(echo "$feels" | sed 's/+//g')"
today="$(echo "$today" | sed 's/+//g')"
tomorrow="$(echo "$tomorrow" | sed 's/+//g')"
dayafter="$(echo "$dayafter" | sed 's/+//g')"

# Build tooltip
tip="$(cat <<EOF
$location
━━━━━━━━━━━━━━━━━━━━━━
${LABEL_NOW}: $condition
${LABEL_TEMP}: $temp | ${LABEL_FEELS}: $feels
${LABEL_WIND}: $wind | ${LABEL_RAIN}: $rain
${LABEL_HUMIDITY}: $humidity | ${LABEL_PRESSURE}: $pressure

━━━━━━━━━━━━━━━━━━━━━━
$TODAY     $today
$TOMORROW   $tomorrow
$DAYAFTER  $dayafter
EOF
)"

# Clean up extra spaces
bar="$(echo "$bar" | sed 's/  / /g')"

# Output JSON for waybar
jq -nc --arg text "$bar" --arg tooltip "$tip" '{text: $text, tooltip: $tooltip}'
