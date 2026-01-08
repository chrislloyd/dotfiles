#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "* $1"
}

readonly dir="$HOME/Screenshots"
mkdir -p "$dir"

# Count screenshots and recordings before moving
screenshot_count=$(find "$HOME/Desktop" -name "Screen*.png" -type f 2>/dev/null | wc -l | xargs)
recording_count=$(find "$HOME/Desktop" -name "Screen*.mov" -type f 2>/dev/null | wc -l | xargs)
cleanshot_count=$(find "$HOME/Desktop" -name "CleanShot*" -type f 2>/dev/null | wc -l | xargs)
total_count=$((screenshot_count + recording_count + cleanshot_count))

# Move screenshots and recordings if any exist
if [ "$total_count" -gt 0 ]; then
  if [ "$screenshot_count" -gt 0 ]; then
    find "$HOME/Desktop" -name "Screen*.png" -type f -exec mv {} "$dir" \;
  fi
  if [ "$recording_count" -gt 0 ]; then
    find "$HOME/Desktop" -name "Screen*.mov" -type f -exec mv {} "$dir" \;
  fi
  find "$HOME/Desktop" -name "CleanShot*" -type f -exec mv {} "$dir" \; 2>/dev/null || true
  log "Cleaned up $screenshot_count screenshot(s) and $recording_count recording(s)"
else
  log "No screenshots or recordings to clean up"
fi
