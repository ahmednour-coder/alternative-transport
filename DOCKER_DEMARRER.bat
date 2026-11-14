@echo off
setlocal
title Alternative Transport - Docker

cd /d "%~dp0"

echo ============================================
echo   ALTERNATIVE TRANSPORT - Lancement Docker
echo ============================================
echo.

where docker >nul 2>nul
if errorlevel 1 (
    echo [ERREUR] Docker n'est pas installe ou n'est pas dans le PATH.
    pause
    exit /b 1
)

docker info >nul 2>nul
if errorlevel 1 (
    echo [INFO] Docker Desktop n'est pas demarre, lancement...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    echo [INFO] Attente du moteur Docker (jusqu'a 120 secondes)...
    set /a tries=0
    :waitloop
    timeout /t 5 /nobreak >nul
    docker info >nul 2>nul
    if not errorlevel 1 goto dockready
    set /a tries+=1
    if %tries% lss 24 goto waitloop
    echo [ERREUR] Le moteur Docker ne repond pas.
    pause
    exit /b 1
    :dockready
    echo [OK] Moteur Docker pret.
)

echo.
echo [1/3] Compilation de l'application Flutter Web...
call flutter build web --release --dart-define=API_BASE_URL=/api
if errorlevel 1 (
    echo [ERREUR] La compilation Flutter a echoue.
    pause
    exit /b 1
)

echo.
echo [2/3] Construction et demarrage des conteneurs...
docker compose up -d --build
if errorlevel 1 (
    echo [ERREUR] docker compose a echoue.
    pause
    exit /b 1
)

echo.
echo [3/3] Ouverture de l'application...
timeout /t 4 /nobreak >nul
start "" http://localhost:8080

echo.
echo ============================================
echo   Application : http://localhost:8080
echo   API         : http://localhost:3000/api/health
echo.
echo   Compte demo : demo@alternative.tn / demo1234
echo ============================================
echo.
docker compose ps
echo.
pause
