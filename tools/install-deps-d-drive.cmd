@echo off
call "%~dp0d-drive-env.cmd"

cd /d "%PROJECT_ROOT%\apps\OpenSignServer"
call npm ci
if errorlevel 1 exit /b %errorlevel%

cd /d "%PROJECT_ROOT%\apps\OpenSign"
call npm ci
if errorlevel 1 exit /b %errorlevel%

echo Dependencies installed with npm cache at %npm_config_cache%
