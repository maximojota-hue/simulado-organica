@echo off
chcp 65001 >nul
title Simulado de Quimica Organica - 2o ano
cd /d "%~dp0"

echo.
echo   Simulado de Quimica Organica - 2o ano
echo   -------------------------------------
echo   Abrindo no navegador...
echo.

set "ARQ=%~dp0simulado.html"
if not exist "%ARQ%" (
  echo   ERRO: simulado.html nao foi encontrado nesta pasta.
  echo   Mantenha este .bat na MESMA pasta do simulado.html.
  echo.
  pause
  exit /b 1
)

set "URL=file:///%ARQ:\=/%"

rem --- 1) Chrome ---
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" (
  start "" "%ProgramFiles%\Google\Chrome\Application\chrome.exe" --allow-file-access-from-files "%URL%"
  exit /b 0
)
if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" (
  start "" "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" --allow-file-access-from-files "%URL%"
  exit /b 0
)
if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" (
  start "" "%LocalAppData%\Google\Chrome\Application\chrome.exe" --allow-file-access-from-files "%URL%"
  exit /b 0
)

rem --- 2) Edge ---
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" (
  start "" "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" --allow-file-access-from-files "%URL%"
  exit /b 0
)
if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" (
  start "" "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" --allow-file-access-from-files "%URL%"
  exit /b 0
)

rem --- 3) Firefox ---
if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" (
  start "" "%ProgramFiles%\Mozilla Firefox\firefox.exe" "%URL%"
  exit /b 0
)
if exist "%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe" (
  start "" "%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe" "%URL%"
  exit /b 0
)

rem --- 4) ultimo recurso: associacao padrao do Windows ---
echo   Nenhum navegador conhecido encontrado. Usando o padrao do Windows...
start "" "%ARQ%"
exit /b 0
