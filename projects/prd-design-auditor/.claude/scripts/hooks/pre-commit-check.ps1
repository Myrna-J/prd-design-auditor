# Git pre-commit hook for Windows PowerShell
# 只保留代码级检查（如格式化、语法分析）。审计逻辑已转移到 commit-msg
$ErrorActionPreference = "Continue"

Write-Host "=== Git Pre-commit Check ===" -ForegroundColor Cyan
Write-Host "✅ 代码纯净度与格式检查通过 (占位)" -ForegroundColor Green
exit 0
