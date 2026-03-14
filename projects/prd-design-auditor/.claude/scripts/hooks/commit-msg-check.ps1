# Git commit-msg hook for Windows PowerShell
param([string]$CommitMsgFile)

$PROJECT_ROOT = git rev-parse --show-toplevel
$SESSION_LOG_DIR = Join-Path $PROJECT_ROOT "docs\logs"

Write-Host "=== Git Commit-msg Audit ===" -ForegroundColor Cyan

# 1. Skip check
if (Test-Path $CommitMsgFile) {
    $Content = Get-Content $CommitMsgFile -Raw
    if ($Content -match "\[skip-review\]") {
        Write-Host "OK: [skip-review] tag detected. Skipping review check." -ForegroundColor Green
        exit 0
    }
}

if (-not (Test-Path $SESSION_LOG_DIR)) {
    Write-Host "ERROR: Directory $SESSION_LOG_DIR not found!" -ForegroundColor Red
    exit 1
}

# 2. Find latest log
$LatestLog = Get-ChildItem -Path $SESSION_LOG_DIR -Filter "session-log-*.md" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($null -eq $LatestLog) {
    Write-Host "ERROR: No session logs found! Please run /evolve" -ForegroundColor Red
    exit 1
}

# 3. Time comparison
$LogTimestamp = [long]([DateTimeOffset]$LatestLog.LastWriteTime).ToUnixTimeSeconds()

$LastCommitTimeStr = git log -1 --format=%ct 2>$null
$LastCommitTimestamp = 0
if (-not [string]::IsNullOrWhiteSpace($LastCommitTimeStr)) {
    $LastCommitTimestamp = [long]$LastCommitTimeStr
}

if ($LogTimestamp -le $LastCommitTimestamp) {
    Write-Host "ERROR: Latest log time is not newer than last commit time!" -ForegroundColor Red
    Write-Host "   Please run /evolve to create a new session log for current changes." -ForegroundColor Yellow
    exit 1
}

Write-Host "OK: Audit passed. Session log is fresh." -ForegroundColor Green
exit 0
