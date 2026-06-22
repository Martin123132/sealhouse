@echo off
set "PROJECT_ROOT=D:\Codex\esignature\src\open-signature"
set "PROJECT_DATA_ROOT=D:\Codex\esignature\data"
set "TEMP=D:\Codex\esignature\tmp"
set "TMP=D:\Codex\esignature\tmp"
set "npm_config_cache=D:\Codex\esignature\cache\npm"
set "PIP_CACHE_DIR=D:\Codex\esignature\cache\pip"
set "PLAYWRIGHT_BROWSERS_PATH=D:\Codex\esignature\cache\ms-playwright"

if not exist "%TEMP%" mkdir "%TEMP%"
if not exist "%npm_config_cache%" mkdir "%npm_config_cache%"
if not exist "%PIP_CACHE_DIR%" mkdir "%PIP_CACHE_DIR%"
if not exist "%PLAYWRIGHT_BROWSERS_PATH%" mkdir "%PLAYWRIGHT_BROWSERS_PATH%"
if not exist "%PROJECT_DATA_ROOT%" mkdir "%PROJECT_DATA_ROOT%"

cd /d "%PROJECT_ROOT%"
