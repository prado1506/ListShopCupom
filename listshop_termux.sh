#!/data/data/com.termux/files/usr/bin/bash
cd ~/ListShopCupom

LOG_DIR="logs"
mkdir -p "$LOG_DIR"

SESSION_NAME="listshopcupom"

case "$1" in
  start)
    # Evita múltiplas instâncias
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      echo "Já está rodando."
      exit 0
    fi

    tmux new-session -d -s "$SESSION_NAME" "python main.py >> logs/main.log 2>&1"
    echo "Bot iniciado em background (tmux session: $SESSION_NAME)."
    ;;
  stop)
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      tmux kill-session -t "$SESSION_NAME"
      echo "Bot parado."
    else
      echo "Bot não está rodando."
    fi
    ;;
  status)
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      echo "Bot rodando."
    else
      echo "Bot parado."
    fi
    ;;
  *)
    echo "Uso: $0 {start|stop|status}"
    ;;
esac
