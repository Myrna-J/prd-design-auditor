# Project Scaffold - Initialization Script
# Functional: Activates project physical defense (Git Hooks) and initializes auto-evolution.
# Platform: Windows (PowerShell)

Write-Host "##################################"
Write-Host "  Project Scaffold - Activation"
Write-Host "##################################"
Write-Host ""

$PROJECT_ROOT = (git rev-parse --show-toplevel 2>$null)
if ($null -eq $PROJECT_ROOT) {
    $PROJECT_ROOT = Get-Location
} else {
    $PROJECT_ROOT = [System.IO.Path]::GetFullPath($PROJECT_ROOT)
}
Set-Location $PROJECT_ROOT

# 1. Check Git Repo
if (-not (Test-Path ".git")) {
    Write-Host "[WARN] Git repo not found, running git init..." -ForegroundColor Yellow
    git init
}

# 2. Install Git Hooks
$HOOKS_SRC = ".claude\scripts\hooks"
$GIT_HOOKS = ".git\hooks"

if (Test-Path $HOOKS_SRC) {
    Write-Host "[HOOK] Injecting commit-msg hook..." -ForegroundColor Cyan
    
    $CommitMsgDest = "$GIT_HOOKS\commit-msg"
    
    $wrapperContent = '#!/bin/sh' + "`n" + 
                      '# Cross-platform bridge' + "`n" +
                      'if [ -f "./.claude/scripts/hooks/commit-msg-check.sh" ]; then' + "`n" + 
                      '    bash "./.claude/scripts/hooks/commit-msg-check.sh" "$1"' + "`n" +
                      'else' + "`n" +
                      '    powershell.exe -ExecutionPolicy Bypass -File "./.claude/scripts/hooks/commit-msg-check.ps1" "$1"' + "`n" +
                      'fi'
                      
    [IO.File]::WriteAllText($CommitMsgDest, $wrapperContent, [Text.Encoding]::ASCII)
    Write-Host "[OK] Generated $CommitMsgDest (Hook Wrapper)" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Could not find hook script directory $HOOKS_SRC" -ForegroundColor Red
}

Write-Host ""

# 3. Initialize Evolution DB
$SKILLS_DIR = ".skills"
$EVOLUTION_DB = "$SKILLS_DIR\evolution-db.json"

if (-not (Test-Path $SKILLS_DIR)) {
    New-Item -ItemType Directory -Force -Path $SKILLS_DIR | Out-Null
    Write-Host "[DIR] Created evolution directory: $SKILLS_DIR" -ForegroundColor Cyan
}

if (-not (Test-Path $EVOLUTION_DB)) {
    Write-Host "[DB] Seeding evolution database (evolution-db.json)..." -ForegroundColor Cyan
    $date = Get-Date -Format 'yyyy-MM-dd'
    $dbContent = "{`n  `"last_pruned`": `"$date`",`n  `"skills`": []`n}"
    [IO.File]::WriteAllText($EVOLUTION_DB, $dbContent, [Text.Encoding]::UTF8)
    Write-Host "[OK] Evolution database initialized." -ForegroundColor Green
} else {
    Write-Host "[OK] Evolution database exists, skipping." -ForegroundColor Green
}

Write-Host ""
Write-Host "##################################"
Write-Host "[GO] Initialization Complete." -ForegroundColor Green
Write-Host "##################################"
