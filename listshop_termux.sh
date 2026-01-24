#!/data/data/com.termux/files/usr/bin/bash

# Configuração do PATH
export PATH=/data/data/com.termux/files/usr/bin:/data/data/com.termux/files/usr/bin/applets:$PATH

PROJECT_DIR="$HOME/ListShopCupom"
LOG_DIR="$PROJECT_DIR/logs"
SESSION_NAME="listshopcupom"

# Função para enviar notificação
notify() {
  termux-notification -t "ListShopCupom" -c "$1"
}

cd "$PROJECT_DIR" || exit 1
mkdir -p "$LOG_DIR"

case "$1" in
  start)
    # Verifica dependência
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }
    # Evita múltiplas instâncias
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      echo "Já está rodando."
      exit 0
    fi
    tmux new-session -d -s "$SESSION_NAME" "python main.py >> logs/main.log 2>&1" \
    && echo "Bot iniciado (tmux: $SESSION_NAME)." \
    && notify "Bot iniciado com sucesso." \
    || { echo "Falhou ao iniciar (tmux)."; notify "Falhou ao iniciar o bot."; exit 1; }
    ;;
  stop)
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      tmux kill-session -t "$SESSION_NAME" \
      && echo "Bot parado." \
      && notify "Bot parado com sucesso." \
      || { echo "Falhou ao parar (tmux)."; notify "Falhou ao parar o bot."; exit 1; }
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
    else
      echo "Bot parado."
    fi
    ;;
  logs)
    # Mostra log ao vivo
    tail -n 200 -f "$LOG_DIR/main.log"
    ;;
  attach)
    # Entra na sessão tmux pra ver o que está acontecendo
    command -v tmux >/dev/null 2>&1 || { echo "Erro: tmux não instalado. Rode: pkg install tmux"; exit 1; }
    tmux attach -t "$SESSION_NAME"
    ;;
  *)
    echo "Uso: $0 {start|stop|status|logs|attach}"
    exit 1
    ;;
esac
