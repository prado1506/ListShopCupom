import json
import logging
import re
import os
import asyncio
from pathlib import Path
from telethon import TelegramClient, events
from telethon.errors import TypeNotFoundError, SessionPasswordNeededError
from config import BOT_TOKEN, API_ID, API_HASH, ALERT_CHAT, KEYWORDS_FILE

# ========================
# Paths
# ========================
BASE_DIR = Path(__file__).parent
LOG_DIR = BASE_DIR / "logs"
LOG_DIR.mkdir(exist_ok=True)
LOG_FILE = LOG_DIR / "listshopcupom.log"

IGNORE_FILE = BASE_DIR / "ignore.json"

# ========================
# Logging
# ========================
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler(LOG_FILE, encoding="utf-8"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger("ListShopCupom")

# ========================
# Helpers JSON
# ========================
def load_json(path, default):
    if not path.exists():
        return default
    try:
        data = json.loads(path.read_text(encoding="utf-8").strip())
        return data if data else default
    except Exception:
        return default

def save_json(path, data):
    path.write_text(
        json.dumps(data, ensure_ascii=False, indent=2),
        encoding="utf-8"
    )

# ========================
# Data
# ========================
def migrate_keywords_old_format(data):
    """Converte formato antigo (dict) para novo formato (list)"""
    if isinstance(data, dict):
        result = []
        for palavra, cfg in data.items():
            result.append({
                "id": len(result) + 1,
                "palavra": palavra,
                "regex": cfg.get("regex") if isinstance(cfg, dict) else None
            })
        return result
    return data if isinstance(data, list) else []

keywords_data = load_json(Path(KEYWORDS_FILE), [])
keywords = migrate_keywords_old_format(keywords_data)

# Garantir que sempre seja uma lista
if not isinstance(keywords, list):
    keywords = []

ignore_list = load_json(IGNORE_FILE, [])

# ========================
# Telegram Client
# ========================
# Verificar configurações
if not API_ID or not API_HASH:
    raise ValueError("Configure API_ID e API_HASH no arquivo .env (obtenha em https://my.telegram.org)")

client = TelegramClient("listshopcupom_session", API_ID, API_HASH)

# ========================
# Utils
# ========================
def extract_quoted(text):
    return re.findall(r'"([^"]+)"', text)

def should_ignore(text):
    t = text.lower()
    return any(term in t for term in ignore_list)

# ========================
# Commands
# ========================

@client.on(events.NewMessage(pattern=r'^/add(\s|$)'))
async def add_keyword(event):
    args = extract_quoted(event.raw_text)

    if not args:
        await event.reply('❌ Uso correto:\n/add "palavra" "regex(opcional)"')
        return

    palavra = args[0].lower()
    regex = args[1] if len(args) > 1 else None

    # Gerar novo ID único
    next_id = max([k.get("id", 0) for k in keywords] + [0]) + 1
    
    # Adicionar nova entrada
    keywords.append({
        "id": next_id,
        "palavra": palavra,
        "regex": regex
    })
    save_json(Path(KEYWORDS_FILE), keywords)

    logger.info(f"Keyword adicionada (ID: {next_id}): {palavra} | regex={regex}")
    await event.reply(f"✅ Palavra adicionada (ID: {next_id}):\n{palavra}\nregex: {regex if regex else '❌'}")

@client.on(events.NewMessage(pattern=r'^/list$'))
async def list_keywords(event):
    if not keywords:
        await event.reply("📭 Nenhuma palavra cadastrada.")
        return

    msg = [f"Total de palavras monitoradas: {len(keywords)}\n"]
    for entry in keywords:
        palavra = entry.get("palavra", "")
        regex = entry.get("regex")
        entry_id = entry.get("id", "?")
        msg.append(f"ID: {entry_id} | Palavra: {palavra}\nregex: {regex if regex else '❌'}\n")

    await event.reply("\n".join(msg))

@client.on(events.NewMessage(pattern=r'^/ignore(\s|$)'))
async def add_ignore(event):
    args = extract_quoted(event.raw_text)

    if not args:
        await event.reply('❌ Uso correto:\n/ignore "termo"')
        return

    termo = args[0].lower()
    if termo not in ignore_list:
        ignore_list.append(termo)
        save_json(IGNORE_FILE, ignore_list)
        logger.info(f"Ignorado: {termo}")

    await event.reply(f"🚫 Ignorado:\n{termo}")

@client.on(events.NewMessage(pattern=r'^/ignorelist$'))
async def ignore_list_cmd(event):
    if not ignore_list:
        await event.reply("📭 Lista de ignorados vazia.")
        return

    msg = ["Lista de ignorados:\n"]
    for t in ignore_list:
        msg.append(f"- {t}")

    await event.reply("\n".join(msg))

# ========================
# Watcher
# ========================
@client.on(events.NewMessage)
async def watcher(event):
    if not event.text:
        return

    text = event.text.lower()

    if should_ignore(text):
        return

    for entry in keywords:
        palavra = entry.get("palavra", "")
        if palavra not in text:
            continue

        regex = entry.get("regex")
        if regex:
            if not re.search(regex, event.text, re.IGNORECASE | re.DOTALL):
                continue

        entry_id = entry.get("id", "?")
        logger.info(f"Match detectado (ID: {entry_id}): {palavra}")
        await client.send_message(
            ALERT_CHAT,
            f"🚨 Palavra detectada (ID: {entry_id})\n\nPalavra: {palavra}\nRegex: {regex or '❌'}\n\n{event.text}"
        )
        break

# ========================
# Start
# ========================
async def connect_client():
    """Conecta o cliente do Telegram"""
    if BOT_TOKEN:
        # Modo bot oficial - inicia com token
        await client.start(bot_token=BOT_TOKEN)
        logger.info("✅ Bot oficial iniciado com sucesso!")
    else:
        # Modo cliente pessoal (compatibilidade)
        await client.start()
        logger.info("✅ Cliente Telethon iniciado com sucesso!")
    
    # Obter informações do bot/usuário
    me = await client.get_me()
    is_bot = await client.is_bot()
    bot_type = "Bot oficial" if is_bot else "Cliente pessoal"
    logger.info(f"Conectado como: {me.first_name} (@{me.username if me.username else 'N/A'}) - {bot_type}")
    
    if is_bot:
        logger.info("🤖 Bot está pronto para receber comandos!")
    else:
        logger.info("👤 Cliente pessoal está monitorando mensagens...")
    
    return is_bot

async def main():
    logger.info("ListShopCupom iniciado.")
    
    max_reconnect_attempts = 5
    reconnect_delay = 10  # segundos
    
    while True:
        try:
            # Conectar o cliente
            is_bot = await connect_client()
            
            # Executar até desconectar
            await client.run_until_disconnected()
            
        except TypeNotFoundError as e:
            logger.warning(f"TypeNotFoundError detectado (sessão pode estar desatualizada): {e}")
            logger.info("Tentando reconectar em 10 segundos...")
            
            try:
                await client.disconnect()
            except:
                pass
            
            await asyncio.sleep(reconnect_delay)
            continue
            
        except (SessionPasswordNeededError, Exception) as e:
            logger.error(f"Erro crítico: {e}")
            
            # Tentar desconectar antes de sair
            try:
                await client.disconnect()
            except:
                pass
            
            # Se não for TypeNotFoundError, parar após algumas tentativas
            max_reconnect_attempts -= 1
            if max_reconnect_attempts <= 0:
                logger.error("Máximo de tentativas de reconexão atingido. Encerrando.")
                raise
            
            logger.info(f"Tentando reconectar em {reconnect_delay} segundos... ({max_reconnect_attempts} tentativas restantes)")
            await asyncio.sleep(reconnect_delay)

if __name__ == "__main__":
    asyncio.run(main())
