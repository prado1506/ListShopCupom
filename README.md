# ListShopCupom

Bot do Telegram que monitora mensagens em grupos e canais para detectar palavras-chave específicas e enviar alertas quando encontradas.

## 📋 Descrição

O **ListShopCupom** é um bot inteligente desenvolvido em Python que monitora conversas no Telegram em tempo real. Quando detecta palavras-chave configuradas nas mensagens, envia alertas para um chat específico. O bot também possui uma interface web (FastAPI) para gerenciar palavras-chave e termos ignorados de forma visual.

## ✨ Funcionalidades

- 🔍 Monitoramento automático de mensagens no Telegram
- 📢 Alertas personalizados quando palavras-chave são detectadas
- 🎯 Suporte a expressões regulares (regex) para filtragem avançada
- 🚫 Lista de termos ignorados para reduzir falsos positivos
- 🌐 Interface web para gerenciamento de configurações
- 📝 Logs detalhados de todas as operações
- 💬 Comandos via Telegram para configuração rápida

## 🔧 Requisitos

- Python 3.11 ou superior
- Conta no Telegram
- API ID e API Hash do Telegram (obtidos em [my.telegram.org](https://my.telegram.org))

## 📦 Instalação

### 1. Clone o repositório

```bash
git clone <url-do-repositorio>
cd ListShopCupom
```

### 2. Crie um ambiente virtual (recomendado)

```bash
python -m venv venv
```

### 3. Ative o ambiente virtual

**Windows:**
```bash
venv\Scripts\activate
```

**Linux/macOS:**
```bash
source venv/bin/activate
```

### 4. Instale as dependências

```bash
pip install -r requirements.txt
```

## ⚙️ Configuração

### 1. Obter credenciais da API do Telegram

1. Acesse [my.telegram.org](https://my.telegram.org)
2. Faça login com seu número de telefone
3. Vá em **API development tools**
4. Crie uma nova aplicação (se necessário)
5. Anote seu **API ID** e **API Hash**

### 2. Criar Bot no Telegram (Opcional mas Recomendado)

Para tornar o bot acessível publicamente:

1. Abra o Telegram e procure por **@BotFather**
2. Envie `/newbot`
3. Escolha um nome e username para o bot
4. Copie o **token** fornecido

### 3. Configurar variáveis de ambiente

Copie `.env.example` para `.env` e configure:

```env
BOT_TOKEN=seu_token_do_botfather  # Obrigatório para bot oficial
API_ID=seu_api_id
API_HASH=seu_api_hash
ALERT_CHAT=me  # ou @username ou chat_id
PORT=8000
```

**Opções para `ALERT_CHAT`:**
- `"me"` - Envia alertas para você mesmo
- `@username` - Envia para um canal/grupo específico
- `chat_id` - ID numérico do chat

### 4. Arquivos de configuração

- `keywords.json` - Palavras-chave monitoradas (criado automaticamente)
- `ignore.json` - Lista de termos ignorados (criado automaticamente)

## 🚀 Execução

### Configuração Inicial

1. Copie o arquivo `.env.example` para `.env`:
```bash
cp .env.example .env
```

2. Edite o arquivo `.env` e configure:
   - `BOT_TOKEN`: Token do bot obtido no @BotFather (obrigatório para bot oficial)
   - `API_ID` e `API_HASH`: Obtidos em https://my.telegram.org
   - `ALERT_CHAT`: Chat para receber alertas (padrão: "me")

### Modo 1: Bot Oficial (Recomendado)

Para tornar o bot acessível publicamente no Telegram:

1. Crie um bot no @BotFather e obtenha o token
2. Configure o `BOT_TOKEN` no arquivo `.env`
3. Execute:
```bash
python main.py
```

### Modo 2: Cliente Pessoal (Compatibilidade)

Para usar com sua conta pessoal (sem bot token):

1. Deixe `BOT_TOKEN` vazio no `.env`
2. Execute:
```bash
python main.py
```

Na primeira execução, você precisará:
1. Inserir seu número de telefone
2. Inserir o código de verificação enviado pelo Telegram
3. Inserir a senha de 2FA (se configurada)

Após a primeira autenticação, uma sessão será salva e você não precisará autenticar novamente.

### Iniciar a interface web

Em outro terminal (mantendo o bot rodando):

```bash
# Ative o ambiente virtual
venv\Scripts\activate  # Windows
# ou
source venv/bin/activate  # Linux/macOS

# Execute o servidor web
uvicorn web:app --reload
```

Acesse a interface web em: **http://localhost:8000**

## 🌐 Deploy em Hospedagem (24/7 Gratuito)

Para hospedar o bot gratuitamente e mantê-lo rodando 24/7, consulte o guia completo em **[DEPLOY.md](DEPLOY.md)**.

**Resumo rápido:**
1. Crie um bot no @BotFather
2. Configure as variáveis de ambiente no Render
3. Faça deploy do código
4. Pronto! Bot disponível 24/7

## 💬 Comandos do Telegram

O bot responde aos seguintes comandos quando enviados via Telegram:

### `/add "palavra" "regex(opcional)"`
Adiciona uma nova palavra-chave para monitoramento.

**Exemplos:**
```
/add "cupom"
/add "desconto" ".*\\d+\\s?%"
/add "frete gratis"
```

### `/list`
Lista todas as palavras-chave cadastradas com seus respectivos regex.

**Resposta:**
```
Total de palavras monitoradas: 5

Palavra: cupom
regex: ❌

Palavra: desconto
regex: .*\d+\s?%
...
```

### `/ignore "termo"`
Adiciona um termo à lista de ignorados. Mensagens contendo esse termo não serão processadas.

**Exemplo:**
```
/ignore "spam"
/ignore "anúncio"
```

### `/ignorelist`
Lista todos os termos na lista de ignorados.

**Resposta:**
```
Lista de ignorados:

- spam
- anúncio
- teste
```

## 🌐 Interface Web

A interface web permite gerenciar palavras-chave e termos ignorados através de uma interface visual.

### Endpoints da API

#### Keywords

- `GET /keywords` - Lista todas as palavras-chave
- `POST /keywords/add` - Adiciona uma palavra-chave
  - Formato: `raw="palavra" "regex(opcional)"`
- `POST /keywords/remove` - Remove uma palavra-chave
  - Formato: `palavra=nome_da_palavra`

#### Ignore

- `GET /ignore` - Lista todos os termos ignorados
- `POST /ignore/add` - Adiciona um termo ignorado
  - Formato: `raw="termo"`
- `POST /ignore/remove` - Remove um termo ignorado
  - Formato: `termo=nome_do_termo`

### Exemplo de uso da API

```bash
# Adicionar palavra-chave
curl -X POST "http://localhost:8000/keywords/add" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d 'raw="cupom"'

# Adicionar palavra-chave com regex
curl -X POST "http://localhost:8000/keywords/add" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d 'raw="desconto" ".*\\d+\\s?%"'

# Remover palavra-chave
curl -X POST "http://localhost:8000/keywords/remove" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d 'palavra=cupom'

# Adicionar termo ignorado
curl -X POST "http://localhost:8000/ignore/add" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d 'raw="spam"'
```

## 📁 Estrutura do Projeto

```
ListShopCupom/
├── main.py              # Bot principal do Telegram
├── web.py               # Servidor FastAPI (interface web)
├── config.py            # Configurações (API_ID, API_HASH, etc.)
├── logger.py            # Configuração de logging
├── requirements.txt     # Dependências do projeto
├── start.bat            # Script de inicialização (Windows)
├── keywords.json        # Palavras-chave (criado automaticamente)
├── ignore.json          # Termos ignorados (criado automaticamente)
├── templates/
│   └── index.html       # Interface web HTML
├── static/
│   └── style.css        # Estilos da interface web
├── logs/
│   └── listshopcupom.log  # Arquivo de logs
└── venv/                # Ambiente virtual Python
```

## 📝 Logs

Todos os eventos são registrados em:
- **Console** - Saída em tempo real
- **Arquivo**: `logs/listshopcupom.log` - Histórico completo

Os logs incluem:
- Inicialização do bot
- Palavras-chave adicionadas/removidas
- Termos ignorados adicionados
- Detecções de palavras-chave
- Erros e exceções

## 🔍 Como Funciona

1. **Monitoramento**: O bot monitora todas as mensagens recebidas nos grupos/canais onde está presente.

2. **Filtro de Ignorados**: Primeiro verifica se a mensagem contém algum termo da lista de ignorados. Se contiver, a mensagem é descartada.

3. **Verificação de Palavras-chave**: Para cada palavra-chave cadastrada:
   - Verifica se a palavra está presente no texto (case-insensitive)
   - Se a palavra-chave possui regex configurado, valida se o texto corresponde ao padrão

4. **Alerta**: Quando uma correspondência é encontrada, o bot envia um alerta para o chat configurado em `ALERT_CHAT`.

## ⚠️ Observações Importantes

### Limitações dos Bots do Telegram

**🤖 Bot Oficial (com BOT_TOKEN):**
- Em **grupos/canais**: Precisa ser **administrador** para ver todas as mensagens
- Em **conversas privadas (DM)**: Funciona perfeitamente, vê todas as mensagens
- Qualquer pessoa pode usar o bot publicamente

**👤 Cliente Pessoal (sem BOT_TOKEN):**
- Pode ver todas as mensagens em grupos onde você é membro
- Não precisa ser administrador
- Usa sua conta pessoal (não é um bot público)

**📚 Para mais detalhes:** Consulte [LIMITACOES_BOTS.md](LIMITACOES_BOTS.md)

### Outras Observações

- O bot precisa estar presente nos grupos/canais que deseja monitorar
- Para adicionar o bot em grupos privados, você precisa ser administrador
- A primeira execução (modo cliente pessoal) requer autenticação com código SMS
- Mantenha as credenciais da API seguras e não as compartilhe publicamente
- O arquivo de sessão (`listshopcupom_session.session`) contém credenciais de autenticação - mantenha-o seguro
- **O deploy na web não muda essas limitações** - são regras do Telegram, não da hospedagem

## 🛠️ Solução de Problemas

### Erro de autenticação
- Verifique se o `API_ID` e `API_HASH` estão corretos
- Delete o arquivo de sessão (`listshopcupom_session.session`) e tente novamente

### Bot não detecta mensagens
- Verifique se o bot está presente no grupo/canal
- Confirme que a palavra-chave está cadastrada corretamente
- Verifique os logs para mais detalhes

### Interface web não carrega
- Certifique-se de que o servidor web está rodando (`uvicorn web:app`)
- Verifique se a porta 8000 está disponível
- Tente acessar `http://localhost:8000` diretamente

## 📄 Licença

Este projeto é de código aberto. Use e modifique conforme necessário.

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests.

---
