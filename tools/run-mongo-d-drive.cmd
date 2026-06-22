@echo off
call "%~dp0d-drive-env.cmd"

set "MONGO_DBPATH=%PROJECT_DATA_ROOT%\mongo"
set "MONGO_RUNNER_DIR=%PROJECT_DATA_ROOT%\mongodb-runner-7"
set "MONGO_LOG_DIR=%PROJECT_DATA_ROOT%\mongodb-logs-7"
set "MONGO_DOWNLOAD_DIR=D:\Codex\esignature\cache\mongodb-runner-downloads-7"
set "MONGO_TMP_DIR=D:\Codex\esignature\tmp\mongodb-runner-7"
if not exist "%MONGO_DBPATH%" mkdir "%MONGO_DBPATH%"
if not exist "%MONGO_RUNNER_DIR%" mkdir "%MONGO_RUNNER_DIR%"
if not exist "%MONGO_LOG_DIR%" mkdir "%MONGO_LOG_DIR%"
if not exist "%MONGO_DOWNLOAD_DIR%" mkdir "%MONGO_DOWNLOAD_DIR%"
if not exist "%MONGO_TMP_DIR%" mkdir "%MONGO_TMP_DIR%"

where mongod >nul 2>nul
if not errorlevel 1 (
  mongod --dbpath "%MONGO_DBPATH%" --port 27017
  exit /b %errorlevel%
)

if not exist "%PROJECT_ROOT%\apps\OpenSignServer\node_modules\.bin\mongodb-runner.cmd" (
  echo mongod was not found on PATH, and mongodb-runner is not installed.
  echo Run tools\install-deps-d-drive.cmd first.
  exit /b 1
)

cd /d "%PROJECT_ROOT%\apps\OpenSignServer"
call node_modules\.bin\mongodb-runner.cmd start -t standalone --version 7.0.x --runnerDir "%MONGO_RUNNER_DIR%" --downloadDir "%MONGO_DOWNLOAD_DIR%" --tmpDir "%MONGO_TMP_DIR%" --logDir "%MONGO_LOG_DIR%" --id sealhouse -- --port 27017 --dbpath "%MONGO_DBPATH%"
