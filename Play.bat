@echo off
rem Starts a small local web server and opens the game in your default browser
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0serve.ps1"
