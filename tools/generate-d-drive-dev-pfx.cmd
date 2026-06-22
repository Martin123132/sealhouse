@echo off
call "%~dp0d-drive-env.cmd"

cd /d "%PROJECT_ROOT%\apps\OpenSignServer"
call node "%PROJECT_ROOT%\tools\generate-d-drive-dev-pfx.mjs"
