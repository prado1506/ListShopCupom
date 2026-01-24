#!/data/data/com.termux/files/usr/bin/bash
<<<<<<< HEAD

# Garante PATH no contexto do Termux:Widget/Task
=======
>>>>>>> 16007b8 (ajustes termux Android)
export PATH=/data/data/com.termux/files/usr/bin:/data/data/com.termux/files/usr/bin/applets:$PATH

PROJECT_DIR="$HOME/ListShopCupom"
LOG_DIR="$PROJECT_DIR/logs"
SESSION_NAME="listshopcupom"

cd "$PROJECT_DIR" || exit 1
mkdir -p "$LOG_DIR"

case "$1" in
  start)
<<<<<<< HEAD
    # Verifica dependência
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }

    # Evita múltiplas instâncias
=======
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }

>>>>>>> 16007b8 (ajustes termux Android)
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      echo "Já está rodando."
      exit 0
    fi

<<<<<<< HEAD
    tmux new-session -d -s "$SESSION_NAME" "python main.py >> logs/main.log 2>&1" \
      && echo "Bot iniciado (tmux: $SESSION_NAME)." \
      || { echo "Falhou ao iniciar (tmux)."; exit 1; }
    ;;

  stop)
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }

    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      tmux kill-session -t "$SESSION_NAME" \
        && echo "Bot parado." \
        || { echo "Falhou ao parar (tmux)."; exit 1; }
=======
    # inicia e já verifica se a sessão ficou viva
    tmux new-session -d -s "$SESSION_NAME" "python main.py >> logs/main.log 2>&1" || { echo "Falhou ao criar sessão tmux."; exit 1; }
    sleep 1

    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      echo "Bot iniciado (tmux: $SESSION_NAME)."
      echo "Log: $LOG_DIR/main.log"
    else
      echo "Bot NÃO ficou rodando. Veja o log: $LOG_DIR/main.log"
      exit 1
    fi
    ;;

  stop)
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }

    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      tmux kill-session -t "$SESSION_NAME" && echo "Bot parado." || { echo "Falhou ao parar."; exit 1; }
>>>>>>> 16007b8 (ajustes termux Android)
    else
      echo "Bot não está rodando."
    fi
    ;;

  status)
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }

    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      echo "Bot rodando."
      echo "Log: $LOG_DIR/main.log"
    else
      echo "Bot parado."
    fi
    ;;

  logs)
<<<<<<< HEAD
    # mostra log ao vivo
    tail -n 200 -f "$LOG_DIR/main.log"
    ;;

  attach)
    # entra na sessão tmux pra ver o que está acontecendo
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }
    tmux attach -t "$SESSION_NAME"
    ;;

  *)
    echo "Uso: $0 {start|stop|status|logs|attach}"
=======
    tail -n 200 -f "$LOG_DIR/main.log"
    ;;

  *)
    echo "Uso: $0 {start|stop|status|logs}"
>>>>>>> 16007b8 (ajustes termux Android)
    exit 1
    ;;
esac
