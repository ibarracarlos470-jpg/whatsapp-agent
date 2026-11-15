@echo off
setlocal enabledelayedexpansion

cd C:\Users\Marcelo\Proyecto\Agentes\whatsapp-agent

set PATH=C:\Program Files\Git\cmd;C:\Program Files\heroku\bin;%PATH%

git config --global user.name "Deploy"
git config --global user.email "deploy@whatsapp.local"

if not exist .git (
    git init
)

git add .

git commit -m "Initial: WhatsApp Agent for Heroku"

git status
git log --oneline -1
