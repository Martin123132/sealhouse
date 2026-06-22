@echo off
call "%~dp0d-drive-env.cmd"

if not exist "%PROJECT_ROOT%\.env.d-drive.example" (
  echo Missing %PROJECT_ROOT%\.env.d-drive.example
  exit /b 1
)

copy /Y "%PROJECT_ROOT%\.env.d-drive.example" "%PROJECT_ROOT%\apps\OpenSign\.env" >nul
copy /Y "%PROJECT_ROOT%\.env.d-drive.example" "%PROJECT_ROOT%\apps\OpenSignServer\.env" >nul

echo Wrote local env files:
echo   %PROJECT_ROOT%\apps\OpenSign\.env
echo   %PROJECT_ROOT%\apps\OpenSignServer\.env
