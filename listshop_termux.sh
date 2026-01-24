#!/data/data/com.termux/files/usr/bin/bash

export PATH=/data/data/com.termux/files/usr/bin:/data/data/com.termux/files/usr/bin/applets:$PATH

PROJECT_DIR="$HOME/ListShopCupom"
LOG_DIR="$PROJECT_DIR/logs"
SESSION_NAME="listshopcupom"

notify() {
  command -v termux-notification >/dev/null 2>&1 || return 0
  termux-notification -t "ListShopCupom" -c "$1"
}

cd "$PROJECT_DIR" || exit 1
mkdir -p "$LOG_DIR"

case "${1:-}" in
  start)
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }

    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      echo "Já está rodando."
      exit 0
    fi

    tmux new-session -d -s "$SESSION_NAME" \
      "bash -lc 'cd "$PROJECT_DIR" && . ./venv/bin/activate && python3 main.py >> logs/main.log 2>&1'" ; \
      split-window -t "$SESSION_NAME" -d \
      "bash -lc 'cd "$PROJECT_DIR" && bash ./notifier.sh >> logs/notifier.log 2>&1'"

    echo "Bot iniciado (tmux: $SESSION_NAME)."
    notify "Bot iniciado com sucesso."
    ;;

  stop)
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      tmux kill-session -t "$SESSION_NAME"
      echo "Bot parado."
      notify "Bot parado com sucesso."
    else
      echo "Bot não está rodando."
      notify "Bot não está rodando."
    fi
    ;;

  status)
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      echo "Bot rodando."
      echo "Log: $LOG_DIR/main.log"
      echo "Log notifier: $LOG_DIR/notifier.log"
    else
      echo "Bot parado."
    fi
    ;;

  logs)
    tail -n 200 -f "$LOG_DIR/main.log"
    ;;

  attach)
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }
    tmux attach -t "$SESSION_NAME"
    ;;

  *)
    echo "Uso: $0 {start|stop|status|logs|attach}"
    exit 1
    ;;
esac
