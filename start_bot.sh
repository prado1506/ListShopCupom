#!/bin/bash
# Script para iniciar o bot no Linux/macOS

# Ativar ambiente virtual
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Verificar se .env existe
if [ ! -f ".env" ]; then
    echo "⚠️  Arquivo .env não encontrado!"
    echo "📝 Copie .env.example para .env e configure as variáveis"
    exit 1
fi

# Iniciar o bot
echo "🚀 Iniciando ListShopCupom Bot..."
python main.py
