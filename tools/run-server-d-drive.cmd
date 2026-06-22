@echo off
call "%~dp0d-drive-env.cmd"

if not exist "%PROJECT_ROOT%\apps\OpenSignServer\.env" (
  call "%~dp0setup-d-drive-local-env.cmd"
)

cd /d "%PROJECT_ROOT%\apps\OpenSignServer"
call npm start
