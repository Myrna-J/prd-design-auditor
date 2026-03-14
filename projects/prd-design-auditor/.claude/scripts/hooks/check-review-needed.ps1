# 复盘检测脚本
# 检测是否需要执行复盘

param(
    [switch]$Force
)

$PROJECT_ROOT = git rev-parse --show-toplevel
$TODAY = Get-Date -Format "yyyy-MM-dd"
$NOW_HOUR = (Get-Date).Hour

# 检测条件
$NEEDS_REVIEW = $false
$REASON = ""

# 条件1: 记忆系统有变化
$MEMORY_DIR = "$env:USERPROFILE\.claude\projects\d--AICoding-ai-coding-standards\memory"
if (Test-Path $MEMORY_DIR) {
    $MEMORY_FILES = Get-ChildItem $MEMORY_DIR -Filter "*.md"
    foreach ($FILE in $MEMORY_FILES) {
        $LAST_MOD = $FILE.LastWriteTime.ToString("yyyy-MM-dd")
        if ($LAST_MOD -eq $TODAY) {
            $NEEDS_REVIEW = $true
            $REASON = "记忆系统今天有更新"
            break
        }
    }
}

# 条件2: 每日首次对话（早上6点前）
if ($NOW_HOUR -lt 6 -and -not $NEEDS_REVIEW) {
    # 检查今天是否已经复盘过
    $WORK_LOG = "$PROJECT_ROOT\state\work-log.md"
    if (Test-Path $WORK_LOG) {
        $CONTENT = Get-Content $WORK_LOG -Raw
        if (-not ($CONTENT -match "## \d{4}-$TODAY")) {
            $NEEDS_REVIEW = $true
            $REASON = "每日首次对话"
        }
    }
}

# 条件3: 有未提交的对话备份
$DOCS_DIR = "$PROJECT_ROOT\docs"
if (Test-Path $DOCS_DIR) {
    $UNCOMMITTED_BACKUPS = git status --porcelain "$DOCS_DIR" 2>$null | Select-String "session-log"
    if ($UNCOMMITTED_BACKUPS) {
        $NEEDS_REVIEW = $true
        $REASON = "有未提交的对话备份"
    }
}

# 输出结果
if ($NEEDS_REVIEW -or $Force) {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║         ⚠️  检测到需要复盘                ║" -ForegroundColor Yellow
    Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "原因: $REASON" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请执行以下步骤：" -ForegroundColor White
    Write-Host "  1. /evolve 或说'复盘'" -ForegroundColor Cyan
    Write-Host "  2. 更新三重文档 (work-log.md, context.md, dialogue-record.md)" -ForegroundColor Cyan
    Write-Host "  3. Git 提交并推送" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "跳过: Ctrl+C" -ForegroundColor Gray
    Write-Host ""

    # 等待用户确认
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

exit 0
