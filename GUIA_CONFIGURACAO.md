# 📖 Guia Passo a Passo - Configuração Inicial

Este guia explica como configurar o projeto pela primeira vez, passo a passo.

## 🎯 O que você vai fazer:

1. Copiar o arquivo `.env.example` para `.env`
2. Editar o arquivo `.env` e colocar suas credenciais
3. Executar o bot

---

## 📝 Passo 1: Copiar o arquivo `.env.example` para `.env`

### ⚡ Opção SUPER FÁCIL: Usando o script automático

1. No **Explorador de Arquivos**, vá até `D:\DEV\Github\ListShopCupom`
2. Procure pelo arquivo `criar_env.bat`
3. **Dê um duplo clique** nele
4. O script vai criar o arquivo `.env` automaticamente!
5. Ele vai perguntar se você quer abrir o arquivo - digite **S** para abrir e editar

### Opção A: Usando o Explorador de Arquivos (Manual)

1. Abra o **Explorador de Arquivos** do Windows
2. Navegue até a pasta do projeto: `D:\DEV\Github\ListShopCupom`
3. Você verá um arquivo chamado `.env.example`
4. **Clique com o botão direito** no arquivo `.env.example`
5. Selecione **Copiar**
6. **Clique com o botão direito** em uma área vazia da pasta
7. Selecione **Colar**
8. Você verá um arquivo chamado `.env.example - Cópia`
9. **Clique com o botão direito** no arquivo copiado
10. Selecione **Renomear**
11. Renomeie para: `.env` (apenas remova " - Cópia")
12. Pressione **Enter**

**Dica:** Se você não conseguir ver o arquivo `.env.example`, é porque arquivos que começam com ponto (.) podem estar ocultos. Veja na seção "Ver arquivos ocultos" abaixo.

### Opção B: Usando o PowerShell (Linha de Comando)

1. Pressione `Windows + X` e selecione **Windows PowerShell** ou **Terminal**
2. Navegue até a pasta do projeto:
   ```powershell
   cd D:\DEV\Github\ListShopCupom
   ```
3. Copie o arquivo:
   ```powershell
   copy .env.example .env
   ```

### Como ver arquivos ocultos no Windows:

1. Abra o **Explorador de Arquivos**
2. Clique na aba **Exibir** (no topo)
3. Marque a caixa **Itens ocultos** ou **Arquivos ocultos**

---

## 🔑 Passo 2: Obter suas credenciais

Antes de editar o arquivo `.env`, você precisa obter suas credenciais do Telegram.

### 2.1 Obter BOT_TOKEN (Opcional - só se quiser bot oficial)

**Para bot público (recomendado):**
1. Abra o Telegram
2. Procure por **@BotFather**
3. Envie o comando `/newbot`
4. Escolha um nome para o bot (ex: "ListShop Cupom Bot")
5. Escolha um username (deve terminar com "bot", ex: "listshopcupom_bot")
6. O BotFather vai enviar um **token** (algo como: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)
7. **Copie esse token** - você vai precisar dele!

**Para uso pessoal apenas (pode pular esta etapa):**
- Deixe o `BOT_TOKEN` vazio no `.env`

### 2.2 Obter API_ID e API_HASH (OBRIGATÓRIO)

1. Abra seu navegador e vá para: https://my.telegram.org
2. Faça login com seu **número de telefone** (incluindo código do país, ex: +5511999999999)
3. Vá em **API development tools**
4. Se você nunca criou uma aplicação:
   - Preencha os campos:
     - **App title**: ListShopCupom (ou qualquer nome)
     - **Short name**: listshopcupom (ou qualquer nome curto)
     - **Platform**: Desktop
   - Clique em **Create application**
5. Você verá:
   - **api_id**: Um número (ex: 12345678)
   - **api_hash**: Uma string longa (ex: abcdef1234567890abcdef1234567890)
6. **Anote esses dois valores** - você vai precisar deles!

---

## ✏️ Passo 3: Editar o arquivo `.env`

Agora você vai editar o arquivo `.env` que acabou de criar.

### Opção A: Usando Bloco de Notas (Mais Simples)

1. No **Explorador de Arquivos**, navegue até `D:\DEV\Github\ListShopCupom`
2. Encontre o arquivo `.env`
3. **Clique com o botão direito** no arquivo `.env`
4. Selecione **Abrir com** → **Bloco de Notas**
5. Você verá algo assim:
   ```
   BOT_TOKEN=seu_bot_token_aqui
   API_ID=seu_api_id_aqui
   API_HASH=seu_api_hash_aqui
   ALERT_CHAT=me
   PORT=8000
   ```
6. Substitua os valores:
   - `seu_bot_token_aqui` → Cole o token que você obteve do @BotFather (ou deixe vazio se não usar bot)
   - `seu_api_id_aqui` → Cole o API ID que você obteve (apenas o número)
   - `seu_api_hash_aqui` → Cole o API Hash que você obteve (a string longa)
7. **Salve o arquivo**: `Ctrl + S` ou Arquivo → Salvar

### Opção B: Usando o Visual Studio Code ou Cursor

1. Abra o arquivo `.env` no VS Code/Cursor
2. Edite os valores da mesma forma
3. Salve o arquivo

### Exemplo de como deve ficar:

```
BOT_TOKEN=123456789:ABCdefGHIjklMNOpqrsTUVwxyz
API_ID=31593953
API_HASH=a4c7391f4ce6535e5de58132e006e0e0
ALERT_CHAT=me
PORT=8000
```

**⚠️ IMPORTANTE:**
- Não coloque espaços antes ou depois do `=`
- Não coloque aspas nos valores (a menos que o valor tenha espaços)
- Mantenha tudo em uma linha por configuração

---

## 🚀 Passo 4: Executar o bot

Agora que tudo está configurado, você pode executar o bot!

### Opção A: Usando o arquivo `start.bat` (Mais Fácil)

1. No **Explorador de Arquivos**, vá até `D:\DEV\Github\ListShopCupom`
2. Procure pelo arquivo `start.bat`
3. **Dê um duplo clique** nele
4. Uma janela do terminal vai abrir e o bot vai iniciar

### Opção B: Usando o PowerShell/Terminal

1. Abra o **PowerShell** ou **Terminal**
2. Navegue até a pasta:
   ```powershell
   cd D:\DEV\Github\ListShopCupom
   ```
3. Ative o ambiente virtual:
   ```powershell
   .\venv\Scripts\Activate.ps1
   ```
4. Execute o bot:
   ```powershell
   python main.py
   ```

### O que vai acontecer:

- Se você configurou `BOT_TOKEN`: O bot vai iniciar como bot oficial
- Se você **não** configurou `BOT_TOKEN`: O bot vai pedir seu número de telefone e código de verificação

---

## ✅ Verificando se funcionou

Se tudo deu certo, você verá mensagens como:

```
ListShopCupom iniciado.
✅ Bot oficial iniciado com sucesso!
Conectado como: Seu Bot (@seu_bot) - Bot oficial
🤖 Bot está pronto para receber comandos!
```

ou (se usar modo pessoal):

```
ListShopCupom iniciado.
✅ Cliente Telethon iniciado com sucesso!
Conectado como: Seu Nome (@seu_usuario) - Cliente pessoal
👤 Cliente pessoal está monitorando mensagens...
```

---

## 🆘 Problemas Comuns

### Erro: "arquivo .env não encontrado"
- Certifique-se de que você copiou `.env.example` para `.env` corretamente
- Verifique se está na pasta certa: `D:\DEV\Github\ListShopCupom`

### Erro: "Configure API_ID e API_HASH"
- Abra o arquivo `.env` e verifique se `API_ID` e `API_HASH` estão preenchidos
- Certifique-se de que não há espaços extras

### Erro: "Invalid bot token"
- Verifique se copiou o token completo do @BotFather
- Certifique-se de que não há espaços antes ou depois

### Não consigo ver o arquivo `.env.example`
- Arquivos que começam com ponto podem estar ocultos
- Ative a visualização de arquivos ocultos no Windows (veja acima)

---

## 📚 Próximos Passos

Depois que o bot estiver funcionando localmente:

1. Teste os comandos no Telegram (`/add`, `/list`, etc.)
2. Adicione palavras-chave para monitorar
3. Quando estiver tudo funcionando, você pode fazer o deploy no Render (veja `DEPLOY.md`)

---

**Precisa de ajuda?** Verifique os outros arquivos de documentação ou veja os logs em `logs/listshopcupom.log`
