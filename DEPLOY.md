# 🚀 Guia de Deploy - ListShopCupom

Este guia explica como hospedar o bot gratuitamente no Render e torná-lo acessível como bot oficial do Telegram.

## 📋 Pré-requisitos

1. Conta no GitHub (ou GitLab/Bitbucket)
2. Conta no Render (gratuita): https://render.com
3. Conta no Telegram

## 🔧 Passo 1: Criar o Bot no Telegram

1. Abra o Telegram e procure por **@BotFather**
2. Envie o comando `/newbot`
3. Escolha um nome para o bot (ex: "ListShop Cupom Bot")
4. Escolha um username único (deve terminar com "bot", ex: "listshopcupom_bot")
5. **Copie o token** que o BotFather fornecer (formato: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

## 🔑 Passo 2: Obter API ID e API Hash

1. Acesse https://my.telegram.org
2. Faça login com seu número de telefone
3. Vá em **API development tools**
4. Crie uma nova aplicação (se necessário)
5. Anote seu **API ID** (número) e **API Hash** (string)

## 📦 Passo 3: Preparar o Repositório

1. Faça commit e push do código para o GitHub:
```bash
git add .
git commit -m "Preparado para deploy"
git push origin main
```

## 🌐 Passo 4: Deploy no Render

### 4.1 Criar Novo Serviço

1. Acesse https://render.com e faça login
2. Clique em **New +** → **Background Worker**
3. Conecte seu repositório do GitHub
4. Selecione o repositório `ListShopCupom`

### 4.2 Configurar o Worker (Bot)

**Configurações básicas:**
- **Name**: `listshopcupom-bot`
- **Environment**: `Python 3`
- **Build Command**: `pip install -r requirements.txt`
- **Start Command**: `python main.py`

**Variáveis de Ambiente:**
Adicione as seguintes variáveis:

```
BOT_TOKEN=seu_token_do_botfather
API_ID=seu_api_id
API_HASH=seu_api_hash
ALERT_CHAT=me
PORT=8000
```

### 4.3 Criar Serviço Web (Interface)

1. Clique em **New +** → **Web Service**
2. Conecte o mesmo repositório
3. Configure:
   - **Name**: `listshopcupom-web`
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn web:app --host 0.0.0.0 --port $PORT`

**Variáveis de Ambiente:**
```
PORT=8000
```

### 4.4 Deploy

1. Clique em **Create Background Worker** e **Create Web Service**
2. Aguarde o build e deploy (pode levar alguns minutos)
3. Verifique os logs para garantir que está funcionando

## ✅ Passo 5: Configurar o Bot no Telegram

1. Envie `/setcommands` para o @BotFather
2. Selecione seu bot
3. Envie os comandos:

```
add - Adiciona uma palavra-chave para monitoramento
list - Lista todas as palavras-chave cadastradas
ignore - Adiciona um termo à lista de ignorados
ignorelist - Lista todos os termos ignorados
```

4. (Opcional) Configure descrição e imagem do bot:
   - `/setdescription` - Descrição do bot
   - `/setuserpic` - Foto de perfil do bot

## 🎯 Passo 6: Usar o Bot

1. Procure seu bot no Telegram pelo username que você criou
2. Envie `/start` para iniciar
3. Adicione o bot aos grupos/canais que deseja monitorar
4. Use os comandos para configurar palavras-chave

**⚠️ IMPORTANTE - Limitações dos Bots do Telegram:**

Existem diferenças importantes entre usar como **Bot Oficial** vs **Cliente Pessoal**:

### 🤖 Bot Oficial (com BOT_TOKEN):
Bots oficiais do Telegram têm **limitações** sobre quais mensagens podem ver:

1. **Em Grupos/Canais:**
   - ✅ **Se for ADMINISTRADOR**: Pode ver **todas as mensagens** do grupo/canal
   - ❌ **Se NÃO for administrador**: Só vê mensagens que:
     - Mencionam o bot diretamente (ex: `@seu_bot`)
     - São respostas a mensagens do bot
     - São comandos enviados ao bot

2. **Conversas Privadas (DM):**
   - ✅ Pode ver **todas as mensagens** enviadas diretamente ao bot
   - Qualquer pessoa pode conversar com o bot e ele verá todas as mensagens

### 👤 Cliente Pessoal (sem BOT_TOKEN):
Se você usar sem `BOT_TOKEN` (modo cliente pessoal com sua conta):
- ✅ Pode ver **todas as mensagens** de grupos/canais onde você está membro
- ✅ Não precisa ser administrador
- ⚠️ **ATENÇÃO**: Usa sua conta pessoal, então você precisa estar presente nos grupos

### 💡 Recomendações:

**Para monitorar grupos públicos:**
- Opção 1: Adicione o bot como **administrador** do grupo
- Opção 2: Use modo **cliente pessoal** (sem BOT_TOKEN) se você for membro do grupo

**Para uso pessoal/privado:**
- Use o bot em **conversas diretas (DM)** - funciona perfeitamente sem ser admin
- Qualquer pessoa pode conversar com o bot e ele monitorará as mensagens

**Nota:** O deploy na web funciona da mesma forma - as limitações são do Telegram, não da hospedagem!

## 🔍 Monitoramento

- **Logs do Bot**: Render Dashboard → Seu Worker → Logs
- **Logs da Web**: Render Dashboard → Seu Web Service → Logs
- **Interface Web**: Acesse a URL fornecida pelo Render (ex: `https://listshopcupom-web.onrender.com`)

## 💡 Dicas

1. **Plano Gratuito do Render:**
   - O serviço pode "dormir" após 15 minutos de inatividade
   - Para manter sempre ativo, considere usar um serviço de "ping" ou upgrade para plano pago

2. **Manter Bot Ativo:**
   - O bot do Telegram mantém conexão ativa, então não deve "dormir"
   - Se o worker parar, o Render reinicia automaticamente

3. **Variáveis Sensíveis:**
   - Nunca compartilhe seu `BOT_TOKEN`, `API_ID` ou `API_HASH`
   - Use variáveis de ambiente no Render (não commite no código)

## 🆘 Solução de Problemas

### Bot não responde
- Verifique os logs no Render
- Confirme que o `BOT_TOKEN` está correto
- Verifique se o bot está online no Telegram

### Erro de autenticação
- Confirme que `API_ID` e `API_HASH` estão corretos
- Verifique se não há espaços extras nas variáveis de ambiente

### Bot não detecta mensagens
- Certifique-se de que o bot é administrador do grupo/canal
- Verifique se as palavras-chave estão cadastradas (`/list`)

## 📚 Recursos

- [Documentação do Render](https://render.com/docs)
- [Telegram Bot API](https://core.telegram.org/bots/api)
- [Telethon Documentation](https://docs.telethon.dev/)

---

**Pronto!** Seu bot está hospedado e acessível 24/7! 🎉
