$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
if (-not $projectRoot.StartsWith("D:\", [StringComparison]::OrdinalIgnoreCase)) {
  throw "PROJECT_ROOT must be on the D drive: $projectRoot"
}

$workspaceRoot = (Resolve-Path (Join-Path $projectRoot "..\..")).Path
if (-not $env:PROJECT_DATA_ROOT -or -not $env:PROJECT_DATA_ROOT.StartsWith("D:\", [StringComparison]::OrdinalIgnoreCase)) {
  $env:PROJECT_DATA_ROOT = Join-Path $workspaceRoot "data"
}

$env:TEMP = Join-Path $workspaceRoot "tmp"
$env:TMP = $env:TEMP
$env:npm_config_cache = Join-Path $workspaceRoot "cache\npm"
$env:PIP_CACHE_DIR = Join-Path $workspaceRoot "cache\pip"
$env:PLAYWRIGHT_BROWSERS_PATH = Join-Path $workspaceRoot "cache\ms-playwright"

foreach ($path in @($env:TEMP, $env:npm_config_cache, $env:PIP_CACHE_DIR, $env:PLAYWRIGHT_BROWSERS_PATH, $env:PROJECT_DATA_ROOT)) {
  New-Item -ItemType Directory -Force -Path $path | Out-Null
}

$logDir = Join-Path $env:TEMP "sealhouse-fullstack-smoke"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

function Test-Port {
  param([int] $Port)

  $client = [Net.Sockets.TcpClient]::new()
  try {
    $client.Connect("127.0.0.1", $Port)
    return $true
  } catch {
    return $false
  } finally {
    $client.Dispose()
  }
}

function Wait-Port {
  param(
    [int] $Port,
    [int] $TimeoutSeconds = 60
  )

  $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
  while ((Get-Date) -lt $deadline) {
    if (Test-Port -Port $Port) {
      return
    }
    Start-Sleep -Seconds 1
  }

  throw "Timed out waiting for 127.0.0.1:$Port"
}

function Wait-Url {
  param(
    [string] $Url,
    [int] $TimeoutSeconds = 90
  )

  $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
  $lastError = $null
  while ((Get-Date) -lt $deadline) {
    try {
      $response = Invoke-WebRequest -UseBasicParsing -Uri $Url -TimeoutSec 5
      if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 500) {
        return $response
      }
    } catch {
      $lastError = $_.Exception.Message
    }
    Start-Sleep -Seconds 1
  }

  throw "Timed out waiting for $Url. Last error: $lastError"
}

function Start-Tool {
  param(
    [string] $Name,
    [string] $ScriptName
  )

  $stdout = Join-Path $logDir "$Name-out.log"
  $stderr = Join-Path $logDir "$Name-err.log"
  Remove-Item -Force -ErrorAction SilentlyContinue $stdout, $stderr

  $scriptPath = Join-Path $PSScriptRoot $ScriptName
  $process = Start-Process -FilePath "cmd.exe" `
    -ArgumentList @("/c", "`"$scriptPath`"") `
    -WorkingDirectory $projectRoot `
    -WindowStyle Hidden `
    -RedirectStandardOutput $stdout `
    -RedirectStandardError $stderr `
    -PassThru

  [pscustomobject]@{
    Name = $Name
    LauncherPid = $process.Id
    Stdout = $stdout
    Stderr = $stderr
  }
}

$started = @()

if (Test-Port -Port 27017) {
  Write-Output "MongoDB already listening on http://127.0.0.1:27017"
} else {
  $started += Start-Tool -Name "mongo" -ScriptName "run-mongo-d-drive.cmd"
  Wait-Port -Port 27017 -TimeoutSeconds 90
  Write-Output "MongoDB listening on 127.0.0.1:27017"
}

if (Test-Port -Port 8080) {
  Write-Output "Sealhouse server already listening on http://127.0.0.1:8080"
} else {
  $started += Start-Tool -Name "server" -ScriptName "run-server-d-drive.cmd"
}

$server = Wait-Url -Url "http://127.0.0.1:8080/" -TimeoutSeconds 120
if ($server.Content -notlike "*sealhouse-server is running*") {
  throw "Unexpected server response from http://127.0.0.1:8080/"
}
Write-Output "Sealhouse server healthy at http://127.0.0.1:8080/"

if (Test-Port -Port 5173) {
  Write-Output "Sealhouse client already listening on http://127.0.0.1:5173"
} else {
  $started += Start-Tool -Name "client" -ScriptName "run-client-d-drive.cmd"
}

$client = Wait-Url -Url "http://127.0.0.1:5173/" -TimeoutSeconds 90
if ($client.Content -notlike "*root*") {
  throw "Unexpected client response from http://127.0.0.1:5173/"
}
Write-Output "Sealhouse client healthy at http://127.0.0.1:5173/"

Write-Output ""
Write-Output "D-drive smoke logs: $logDir"
foreach ($entry in $started) {
  Write-Output "$($entry.Name) launcher PID $($entry.LauncherPid)"
  Write-Output "  stdout: $($entry.Stdout)"
  Write-Output "  stderr: $($entry.Stderr)"
}
