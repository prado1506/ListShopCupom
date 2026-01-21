@echo off
echo ========================================
echo   Criar arquivo .env
echo ========================================
echo.

REM Verificar se .env.example existe, se não existir, criar
if not exist .env.example (
    echo [INFO] Arquivo .env.example nao encontrado. Criando...
    (
        echo # Token do Bot do Telegram (obrigatorio para bot oficial)
        echo # Obtenha em: https://t.me/BotFather
        echo BOT_TOKEN=seu_bot_token_aqui
        echo.
        echo # API ID e API Hash do Telegram (obrigatorio)
        echo # Obtenha em: https://my.telegram.org
        echo API_ID=seu_api_id_aqui
        echo API_HASH=seu_api_hash_aqui
        echo.
        echo # Chat para receber alertas (pode ser "me", @username ou chat_id)
        echo ALERT_CHAT=me
        echo.
        echo # Porta do servidor web (Render define automaticamente)
        echo PORT=8000
    ) > .env.example
    if exist .env.example (
        echo [OK] Arquivo .env.example criado!
    ) else (
        echo [ERRO] Falha ao criar .env.example
        pause
        exit /b 1
    )
    echo.
)

REM Verificar se .env já existe
if exist .env (
    echo [AVISO] Arquivo .env ja existe!
    echo Deseja sobrescrever? (S/N)
    set /p resposta=
    if /i not "%resposta%"=="S" (
        echo Operacao cancelada.
        pause
        exit /b 0
    )
)

REM Copiar .env.example para .env
echo [INFO] Copiando .env.example para .env...
copy .env.example .env >nul 2>&1

if exist .env (
    echo [OK] Arquivo .env criado com sucesso!
    echo.
    echo ========================================
    echo   Proximo passo:
    echo ========================================
    echo 1. Abra o arquivo .env com o Bloco de Notas
    echo 2. Preencha suas credenciais:
    echo    - BOT_TOKEN (opcional - so se quiser bot oficial)
    echo    - API_ID (obrigatorio)
    echo    - API_HASH (obrigatorio)
    echo 3. Salve o arquivo (Ctrl+S)
    echo 4. Execute start.bat para iniciar o bot
    echo.
    echo ========================================
    echo.
    echo Deseja abrir o arquivo .env agora? (S/N)
    set /p abrir=
    if /i "%abrir%"=="S" (
        start notepad .env
        echo [INFO] Arquivo .env aberto no Bloco de Notas
    )
) else (
    echo [ERRO] Falha ao criar arquivo .env
    echo [INFO] Tente copiar manualmente: copy .env.example .env
)

echo.
pause
