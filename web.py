from fastapi import FastAPI, Form, HTTPException, Request
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from pathlib import Path
import json
import shlex
import os
from config import PORT

app = FastAPI(title="ListShopCupom")

BASE_DIR = Path(__file__).parent
KEYWORDS_FILE = BASE_DIR / "keywords.json"
IGNORE_FILE = BASE_DIR / "ignore.json"

# -------------------------
# Templates e Static
# -------------------------
templates = Jinja2Templates(directory=str(BASE_DIR / "templates"))
app.mount(
    "/static",
    StaticFiles(directory=str(BASE_DIR / "static")),
    name="static",
)

# -------------------------
# Utils
# -------------------------
def load_json(path: Path, default):
    if not path.exists():
        return default
    content = path.read_text(encoding="utf-8").strip()
    if not content:
        return default
    try:
        return json.loads(content)
    except json.JSONDecodeError:
        return default


def save_json(path: Path, data):
    path.write_text(
        json.dumps(data, indent=2, ensure_ascii=False),
        encoding="utf-8",
    )


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


def parse_quoted_args(raw: str):
    """
    Exemplo: '"cupom sophee" ".*\\\\d+\\\\s?%"'
    """
    try:
        return shlex.split(raw)
    except ValueError:
        raise HTTPException(status_code=400, detail="Erro ao interpretar argumentos")


# -------------------------
# Home (HTML)
# -------------------------
@app.get("/")
def index(request: Request):
    keywords_data = load_json(KEYWORDS_FILE, [])
    keywords = migrate_keywords_old_format(keywords_data)
    if not isinstance(keywords, list):
        keywords = []
    ignores = load_json(IGNORE_FILE, [])
    return templates.TemplateResponse(
        "index.html",
        {
            "request": request,
            "keywords": keywords,
            "ignores": ignores,
            "total_keywords": len(keywords),
            "total_ignores": len(ignores),
        },
    )


# -------------------------
# Keywords
# -------------------------
@app.get("/keywords")
def list_keywords():
    keywords_data = load_json(KEYWORDS_FILE, [])
    keywords = migrate_keywords_old_format(keywords_data)
    if not isinstance(keywords, list):
        keywords = []
    return keywords


@app.post("/keywords/add")
def add_keyword(raw: str = Form(...)):
    args = parse_quoted_args(raw)
    if len(args) == 0:
        raise HTTPException(status_code=400, detail="Informe ao menos a palavra")

    palavra = args[0].lower()
    regex = args[1] if len(args) > 1 else None

    keywords_data = load_json(KEYWORDS_FILE, [])
    keywords = migrate_keywords_old_format(keywords_data)
    if not isinstance(keywords, list):
        keywords = []

    # Gerar novo ID único
    next_id = max([k.get("id", 0) for k in keywords] + [0]) + 1

    # Adicionar nova entrada
    keywords.append({
        "id": next_id,
        "palavra": palavra,
        "regex": regex
    })
    save_json(KEYWORDS_FILE, keywords)

    return {"status": "ok", "id": next_id, "palavra": palavra, "regex": regex}


@app.post("/keywords/remove")
def remove_keyword(keyword_id: str = Form(...)):
    try:
        keyword_id_int = int(keyword_id)
    except (ValueError, TypeError):
        raise HTTPException(status_code=400, detail="ID inválido")
    
    keywords_data = load_json(KEYWORDS_FILE, [])
    keywords = migrate_keywords_old_format(keywords_data)
    if not isinstance(keywords, list):
        keywords = []

    # Buscar por ID
    original_len = len(keywords)
    keywords = [k for k in keywords if k.get("id") != keyword_id_int]

    if len(keywords) == original_len:
        raise HTTPException(status_code=404, detail="Palavra não encontrada")

    save_json(KEYWORDS_FILE, keywords)
    return {"status": "ok", "removed_id": keyword_id_int}


# -------------------------
# Ignore
# -------------------------
@app.get("/ignore")
def list_ignores():
    return load_json(IGNORE_FILE, [])


@app.post("/ignore/add")
def add_ignore(raw: str = Form(...)):
    args = parse_quoted_args(raw)
    if len(args) == 0:
        raise HTTPException(status_code=400, detail='Uso correto: "termo"')

    termo = args[0].lower()
    ignores = load_json(IGNORE_FILE, [])

    if termo not in ignores:
        ignores.append(termo)
        save_json(IGNORE_FILE, ignores)

    return {"status": "ok", "added": termo}


@app.post("/ignore/remove")
def remove_ignore(termo: str = Form(...)):
    termo = termo.lower()
    ignores = load_json(IGNORE_FILE, [])

    if termo not in ignores:
        raise HTTPException(status_code=404, detail="Termo não encontrado")

    ignores.remove(termo)
    save_json(IGNORE_FILE, ignores)

    return {"status": "ok", "removed": termo}


# Para executar o servidor web diretamente
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=PORT)

