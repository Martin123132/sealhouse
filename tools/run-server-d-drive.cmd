@echo off
call "%~dp0d-drive-env.cmd"

if not exist "%PROJECT_ROOT%\apps\OpenSignServer\.env" (
  call "%~dp0setup-d-drive-local-env.cmd"
)

if not exist "%PROJECT_ROOT%\apps\OpenSignServer\files\files" mkdir "%PROJECT_ROOT%\apps\OpenSignServer\files\files"
if not exist "%PROJECT_ROOT%\apps\OpenSignServer\exports" mkdir "%PROJECT_ROOT%\apps\OpenSignServer\exports"

cd /d "%PROJECT_ROOT%\apps\OpenSignServer"

set "NODE_MAJOR="
for /f "usebackq delims=" %%V in (`node -p "process.versions.node.split('.')[0]" 2^>nul`) do set "NODE_MAJOR=%%V"

if "%NODE_MAJOR%"=="18" goto use_system_node
if "%NODE_MAJOR%"=="20" goto use_system_node
if "%NODE_MAJOR%"=="22" goto use_system_node

echo System Node major version "%NODE_MAJOR%" is outside the supported range 18/20/22.
echo Starting Sealhouse server with Node 22 through the D-drive npm cache.
call npx.cmd -y -p node@22 node index.js
exit /b %errorlevel%

:use_system_node
call node index.js
