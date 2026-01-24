#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

PROJECT_DIR="$HOME/ListShopCupom"
LOG_FILE="$PROJECT_DIR/logs/main.log"

# Padrão que dispara a notificação (ajuste se quiser)
PATTERN="Match detectado"

# Usa um ID fixo para atualizar a mesma notificação (evita spam)
NOTIF_ID="listshopcupom-match"

# Garante que o arquivo existe
mkdir -p "$(dirname "$LOG_FILE")"
touch "$LOG_FILE"

# Lê novas linhas do log continuamente
tail -n 0 -F "$LOG_FILE" | while IFS= read -r line; do
  if [[ "$line" == *"$PATTERN"* ]]; then
    # Exemplo de linha:
    # 2026-01-24 13:44:13,465 [INFO] Match detectado (ID: 2): cupom
    termux-notification --id "$NOTIF_ID" -t "ListShopCupom" -c "$line"
  fi
done
