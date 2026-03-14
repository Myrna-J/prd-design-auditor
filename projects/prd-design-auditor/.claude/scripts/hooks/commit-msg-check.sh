#!/bin/bash
# Git commit-msg hook
# Checks whether session backup exists and is newer than the previous commit

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
COMMIT_MSG_FILE="$1"

echo "=== Git Commit-msg 穿透式审计 ==="

# 1. 白名单嗅探 [skip-review]
if grep -q "\[skip-review\]" "$COMMIT_MSG_FILE"; then
    echo "✅ 检测到 [skip-review] 标签，跳过复盘审查。"
    exit 0
fi

SESSION_LOG_DIR="$PROJECT_ROOT/docs/logs"
if [ ! -d "$SESSION_LOG_DIR" ]; then
    echo "❌ 目录 $SESSION_LOG_DIR 不存在，无法进行复盘检查！"
    exit 1
fi

# 2. 寻找最新资产
LATEST_LOG=$(ls -t "$SESSION_LOG_DIR"/session-log-*.md 2>/dev/null | head -n 1)

if [ -z "$LATEST_LOG" ]; then
    echo "❌ 未找到任何复盘日志 (session-log-*.md)！请执行 /evolve 留下复盘日志"
    exit 1
fi

# 3. 时空穿透比对
LOG_MTIME=$(stat -c %Y "$LATEST_LOG")
LAST_COMMIT_TIME=$(git log -1 --format=%ct 2>/dev/null)

if [ -z "$LAST_COMMIT_TIME" ]; then
    # No previous commits
    LAST_COMMIT_TIME=0
fi

if [ "$LOG_MTIME" -le "$LAST_COMMIT_TIME" ]; then
    echo "❌ 审计拦截：最新复盘时间早于或等于上次提交时间！"
    echo "   (可能漏了复盘，或者使用历史复盘蒙混过关)"
    echo "   请执行 /evolve 留下最新的复盘日志后再提交。"
    exit 1
fi

echo "✅ 穿透审计通过：复盘时效性确认"
exit 0
