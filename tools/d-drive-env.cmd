@echo off

for %%I in ("%~dp0..") do set "DEFAULT_PROJECT_ROOT=%%~fI"
if not defined PROJECT_ROOT set "PROJECT_ROOT=%DEFAULT_PROJECT_ROOT%"

if /I not "%PROJECT_ROOT:~0,2%"=="D:" (
  echo PROJECT_ROOT must be on the D drive: %PROJECT_ROOT%
  exit /b 1
)

for %%I in ("%PROJECT_ROOT%\..\..") do set "SEALHOUSE_WORKSPACE_ROOT=%%~fI"
if not defined PROJECT_DATA_ROOT set "PROJECT_DATA_ROOT=%SEALHOUSE_WORKSPACE_ROOT%\data"

set "TEMP=%SEALHOUSE_WORKSPACE_ROOT%\tmp"
set "TMP=%SEALHOUSE_WORKSPACE_ROOT%\tmp"
set "npm_config_cache=%SEALHOUSE_WORKSPACE_ROOT%\cache\npm"
set "PIP_CACHE_DIR=%SEALHOUSE_WORKSPACE_ROOT%\cache\pip"
set "PLAYWRIGHT_BROWSERS_PATH=%SEALHOUSE_WORKSPACE_ROOT%\cache\ms-playwright"

if not exist "%TEMP%" mkdir "%TEMP%"
if not exist "%npm_config_cache%" mkdir "%npm_config_cache%"
if not exist "%PIP_CACHE_DIR%" mkdir "%PIP_CACHE_DIR%"
if not exist "%PLAYWRIGHT_BROWSERS_PATH%" mkdir "%PLAYWRIGHT_BROWSERS_PATH%"
if not exist "%PROJECT_DATA_ROOT%" mkdir "%PROJECT_DATA_ROOT%"

cd /d "%PROJECT_ROOT%"
