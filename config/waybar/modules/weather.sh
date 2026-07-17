#!/usr/bin/env bash
set -euo pipefail

[[ -f "$HOME/.config/notarchy/user.env" ]] && source "$HOME/.config/notarchy/user.env"
LOCATION="${NOTARCHY_LOCATION:-}"
LOCATION_QUERY="${LOCATION// /+}"
CACHEDIR="$HOME/.cache/weather"
CACHEFILE="$CACHEDIR/weather.json"
CACHE_TTL=1800

mkdir -p "$CACHEDIR"

if [[ ! -f "$CACHEFILE" || $(($(date +%s) - $(stat -c %Y "$CACHEFILE"))) -ge $CACHE_TTL ]]; then
  curl -fsS --max-time 5 "https://wttr.in/${LOCATION_QUERY}?format=j1" -o "$CACHEFILE" || true
fi

if [[ ! -s "$CACHEFILE" ]]; then
  printf '{"text":"--°C","tooltip":"No data"}\n'
  exit 0
fi

TEMP="$(jq -r '.current_condition[0].temp_C' "$CACHEFILE")"
FEELS="$(jq -r '.current_condition[0].FeelsLikeC' "$CACHEFILE")"
DESC="$(jq -r '.current_condition[0].weatherDesc[0].value' "$CACHEFILE")"
CITY="$(jq -r '.nearest_area[0].areaName[0].value' "$CACHEFILE")"
HUMIDITY="$(jq -r '.current_condition[0].humidity' "$CACHEFILE")"
WIND="$(jq -r '.current_condition[0].windspeedKmph' "$CACHEFILE")"
WIND_DIR="$(jq -r '.current_condition[0].winddir16Point' "$CACHEFILE")"
MAX="$(jq -r '.weather[0].maxtempC' "$CACHEFILE")"
MIN="$(jq -r '.weather[0].mintempC' "$CACHEFILE")"

case "$DESC" in
  *rain*|*Rain*) ICON="🌧️" ;;
  *storm*|*Thunder*) ICON="⛈️" ;;
  *cloud*|*Cloud*) ICON="⛅" ;;
  *sun*|*Sun*) ICON="☀️" ;;
  *clear*|*Clear*) ICON="🌙" ;;
  *) ICON="🌡️" ;;
esac

jq -cn \
  --arg text "$ICON ${TEMP}°C" \
  --arg tooltip "$CITY
$DESC
Temp: ${TEMP}°C (Feels like: ${FEELS}°C)
Max: ${MAX}°C | Min: ${MIN}°C
Humidity: ${HUMIDITY}%
Wind: ${WIND} km/h ${WIND_DIR}" \
  '{text: $text, tooltip: $tooltip}'
