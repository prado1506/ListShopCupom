import os
from dotenv import load_dotenv

load_dotenv()

# Para bot oficial do Telegram (obrigatório)
BOT_TOKEN = os.getenv("BOT_TOKEN", "")

# Para cliente Telethon (opcional, apenas se usar conta pessoal)
API_ID = int(os.getenv("API_ID", "0"))
API_HASH = os.getenv("API_HASH", "")

# Configurações
ALERT_CHAT = os.getenv("ALERT_CHAT", "me")  # ID do chat ou "me"
BLACKLIST_CHATS = os.getenv("BLACKLIST_CHATS", "").split(",") if os.getenv("BLACKLIST_CHATS") else []
KEYWORDS_FILE = "keywords.json"

# Lista de destinos para notificação (separados por vírgula)
# Exemplo no .env: ALERT_RECIPIENTS=me,@llaryssavictoria
ALERT_RECIPIENTS = os.getenv("ALERT_RECIPIENTS", ALERT_CHAT).split(",")

# Porta para o servidor web (Render define automaticamente)
PORT = int(os.getenv("PORT", "8000"))
