@echo off
call "%~dp0d-drive-env.cmd"

if not exist "%PROJECT_ROOT%\apps\OpenSign\.env" (
  call "%~dp0setup-d-drive-local-env.cmd"
)

if "%OPEN_SIGNATURE_CLIENT_HOST%"=="" set "OPEN_SIGNATURE_CLIENT_HOST=127.0.0.1"
if "%OPEN_SIGNATURE_CLIENT_PORT%"=="" set "OPEN_SIGNATURE_CLIENT_PORT=5173"

cd /d "%PROJECT_ROOT%\apps\OpenSign"
call npm run dev -- --host %OPEN_SIGNATURE_CLIENT_HOST% --port %OPEN_SIGNATURE_CLIENT_PORT% --strictPort
