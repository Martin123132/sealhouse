@echo off
setlocal

call "%~dp0d-drive-env.cmd"
cd /d "%PROJECT_ROOT%\apps\OpenSign"

node -e "const fs=require('fs'); const pkg=require('./package.json'); fs.writeFileSync('./public/version.txt', pkg.version + '\n');"
if errorlevel 1 exit /b %errorlevel%

set "NODE_OPTIONS=--max-old-space-size=8192"
npm.cmd exec vite build -- --minify=false
