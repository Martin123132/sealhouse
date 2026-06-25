$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

$checks = @(
  @{
    Path = ".github/ISSUE_TEMPLATE/bug-report.yml"
    Patterns = @(
      "OpenSign",
      "opensignlabs",
      "app.opensignlabs.com",
      "staging-app.opensignlabs.com",
      "andrew-opensignlabs"
    )
  },
  @{
    Path = ".github/ISSUE_TEMPLATE/feature-request.yml"
    Patterns = @(
      "OpenSign",
      "opensignlabs"
    )
  },
  @{
    Path = "apps/OpenSign/README.md"
    Patterns = @(
      "# Open Sign",
      "Open source is true platform",
      "Create React App"
    )
  },
  @{
    Path = "CODE_OF_CONDUCT.md"
    Patterns = @(
      "open source project"
    )
  }
)

$failures = New-Object System.Collections.Generic.List[string]

foreach ($check in $checks) {
  $path = Join-Path $repoRoot $check.Path
  if (-not (Test-Path -LiteralPath $path)) {
    $failures.Add("Missing expected public file: $($check.Path)")
    continue
  }

  $content = Get-Content -Raw -LiteralPath $path
  foreach ($pattern in $check.Patterns) {
    if ($content -match [regex]::Escape($pattern)) {
      $failures.Add("$($check.Path) contains stale public branding: $pattern")
    }
  }
}

if ($failures.Count -gt 0) {
  foreach ($failure in $failures) {
    Write-Error $failure
  }
  exit 1
}

Write-Host "Public branding guard passed."
