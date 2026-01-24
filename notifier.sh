#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

PROJECT_DIR="$HOME/ListShopCupom"
LOG_FILE="$PROJECT_DIR/logs/main.log"

PATTERN="Match detectado"
NOTIF_ID="listshopcupom-match"

mkdir -p "$(dirname "$LOG_FILE")"
touch "$LOG_FILE"

tail -n 0 -F "$LOG_FILE" | while IFS= read -r line; do
  if [[ "$line" == *"$PATTERN"* ]]; then
    termux-notification --id "$NOTIF_ID" -t "ListShopCupom" -c "$line"
  fi
done
