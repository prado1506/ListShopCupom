@echo off
echo ========================================
echo   ListShopCupom Bot
echo ========================================
echo.

REM Verificar se .env existe
if not exist .env (
    echo [AVISO] Arquivo .env nao encontrado!
    echo [INFO] Copie .env.example para .env e configure as variaveis
    echo.
    pause
    exit /b 1
)

REM Ativar ambiente virtual
if exist venv\Scripts\activate.bat (
    call venv\Scripts\activate.bat
) else (
    echo [AVISO] Ambiente virtual nao encontrado!
    echo [INFO] Execute: python -m venv venv
    echo.
    pause
    exit /b 1
)

echo [INFO] Iniciando bot...
echo.
python main.py
pause