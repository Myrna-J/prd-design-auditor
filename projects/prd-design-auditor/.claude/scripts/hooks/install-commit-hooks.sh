#!/bin/bash
# 安装 Git Hooks

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(git rev-parse --show-toplevel)"
HOOKS_DIR="$PROJECT_ROOT/.git/hooks"

echo "=== 安装 Git Hooks ==="

# 检测操作系统
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows: 使用 PowerShell 脚本
    PRE_TARGET="$HOOKS_DIR/pre-commit"
    MSG_TARGET="$HOOKS_DIR/commit-msg"

    # pre-commit wrapper
    cat > "$PRE_TARGET" <<EOF
#!/bin/bash
powershell.exe -ExecutionPolicy Bypass -File "$SCRIPT_DIR/pre-commit-check.ps1"
EOF

    # commit-msg wrapper
    cat > "$MSG_TARGET" <<EOF
#!/bin/bash
powershell.exe -ExecutionPolicy Bypass -File "$SCRIPT_DIR/commit-msg-check.ps1" -CommitMsgFile "\$1"
EOF

    chmod +x "$PRE_TARGET" "$MSG_TARGET"
    echo "✅ 已安装 Windows pre-commit 和 commit-msg hooks"
else
    # Linux/Mac: 使用 Bash 脚本
    cp "$SCRIPT_DIR/pre-commit-check.sh" "$HOOKS_DIR/pre-commit"
    cp "$SCRIPT_DIR/commit-msg-check.sh" "$HOOKS_DIR/commit-msg"
    chmod +x "$HOOKS_DIR/pre-commit" "$HOOKS_DIR/commit-msg"
    echo "✅ 已安装 Unix pre-commit 和 commit-msg hooks"
fi

echo "   Hook 位置: $HOOKS_DIR"
echo ""
echo "使用说明:"
echo "  - pre-commit: 执行纯粹的代码检查"
echo "  - commit-msg: 执行穿透式审计 (时间戳 + [skip-review])"
echo ""
