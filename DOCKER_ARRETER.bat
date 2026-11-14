@echo off
setlocal
title Alternative Transport - Arret Docker

cd /d "%~dp0"

echo Arret des conteneurs Alternative Transport...
docker compose down

echo.
echo Conteneurs arretes. (Les donnees de la base restent dans le volume api-data.)
echo Pour tout supprimer, y compris la base : docker compose down -v
pause
