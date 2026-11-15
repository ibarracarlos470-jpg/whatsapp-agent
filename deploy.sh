#!/bin/bash

# Script de Deploy a Heroku - WhatsApp Agent

echo "╔════════════════════════════════════════════════════════╗"
echo "║   DEPLOY A HEROKU - WhatsApp Agent                    ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar si Heroku CLI está instalado
if ! command -v heroku &> /dev/null; then
    echo -e "${RED}❌ Heroku CLI no está instalado${NC}"
    echo "Descargalo desde: https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
fi

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker no está instalado${NC}"
    echo "Descargalo desde: https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo -e "${YELLOW}1️⃣  Verificar login a Heroku${NC}"
heroku auth:whoami || (echo "Login a Heroku:"; heroku login)

echo ""
echo -e "${YELLOW}2️⃣  Ingresar nombre de aplicación${NC}"
read -p "Nombre de app (ej: whatsapp-agent-backend-marcelo): " APP_NAME

if [ -z "$APP_NAME" ]; then
    APP_NAME="whatsapp-agent-backend-$(date +%s)"
    echo "Usando: $APP_NAME"
fi

echo ""
echo -e "${YELLOW}3️⃣  Crear app en Heroku${NC}"
heroku create $APP_NAME --buildpack heroku/docker

echo ""
echo -e "${YELLOW}4️⃣  Configurar variables de entorno${NC}"
echo "Ingresa tus credenciales:"
read -p "GEMINI_API_KEY: " GEMINI_KEY
read -p "WHATSAPP_API_TOKEN: " WA_TOKEN
read -p "WHATSAPP_PHONE_NUMBER_ID: " WA_PHONE
read -p "META_VERIFY_TOKEN: " META_TOKEN
read -p "JWT_SECRET: " JWT_SECRET

heroku config:set -a $APP_NAME \
  GEMINI_API_KEY="$GEMINI_KEY" \
  WHATSAPP_API_TOKEN="$WA_TOKEN" \
  WHATSAPP_PHONE_NUMBER_ID="$WA_PHONE" \
  META_VERIFY_TOKEN="$META_TOKEN" \
  JWT_SECRET="$JWT_SECRET" \
  NODE_ENV=production \
  APP_URL="https://$APP_NAME.herokuapp.com"

echo ""
echo -e "${YELLOW}5️⃣  Preparar Git${NC}"
git init
git add .
git commit -m "Deploy WhatsApp Agent Backend to Heroku"

echo ""
echo -e "${YELLOW}6️⃣  Deployar a Heroku${NC}"
git push heroku main

echo ""
echo -e "${GREEN}✅ DEPLOY COMPLETADO!${NC}"
echo ""
echo "URLs:"
echo "  Backend:  https://$APP_NAME.herokuapp.com"
echo "  Health:   https://$APP_NAME.herokuapp.com/health"
echo "  Logs:     heroku logs -a $APP_NAME --tail"
echo ""
echo "Próximo: Deployar frontend"
