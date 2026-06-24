@echo off
call "%~dp0d-drive-env.cmd"

set "SMOKE_LOG_DIR=%TEMP%\sealhouse-fullstack-smoke"
set "SMOKE_STDOUT=%SMOKE_LOG_DIR%\smoke-command-out.log"
set "SMOKE_STDERR=%SMOKE_LOG_DIR%\smoke-command-err.log"
if not exist "%SMOKE_LOG_DIR%" mkdir "%SMOKE_LOG_DIR%"
if exist "%SMOKE_STDOUT%" del "%SMOKE_STDOUT%"
if exist "%SMOKE_STDERR%" del "%SMOKE_STDERR%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0smoke-fullstack-d-drive.ps1" > "%SMOKE_STDOUT%" 2> "%SMOKE_STDERR%"
set "SMOKE_EXIT=%errorlevel%"

if exist "%SMOKE_STDOUT%" type "%SMOKE_STDOUT%"
if not "%SMOKE_EXIT%"=="0" (
  if exist "%SMOKE_STDERR%" type "%SMOKE_STDERR%" 1>&2
)

exit /b %SMOKE_EXIT%
