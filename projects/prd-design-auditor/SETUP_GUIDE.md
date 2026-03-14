# Claude Code 配置中心 - 设置指南

**版本**: v9.0
**更新时间**: 2026-02-08
**配置中心**: `ai-coding-standards/.claude/`

---

## 📋 概述

本配置中心将所有 Claude Code 相关的配置集中管理，实现：
- ✅ **版本控制**: 所有配置都在 git 仓库中
- ✅ **可移植性**: 一键在任何电脑上恢复配置
- ✅ **标准化**: 基于 everything-claude-code 最佳实践
- ✅ **可扩展**: 易于添加新技能和配置

---

## 🗂️ 配置结构

```
ai-coding-standards/
├── .claude/                    # Claude 配置中心
│   ├── agents/                # 13 个专业代理
│   │   ├── planner.md         # 任务规划代理
│   │   ├── code-reviewer.md   # 代码审查代理
│   │   ├── security-reviewer.md # 安全审查代理
│   │   └── ...
│   ├── commands/              # 33 个工作流命令
│   │   ├── plan.md            # 规划任务
│   │   ├── tdd.md             # 测试驱动开发
│   │   ├── code-review.md     # 代码审查
│   │   └── ...
│   ├── rules/                 # 按语言分类的规范
│   │   ├── common/            # 通用规范
│   │   │   ├── coding-style.md
│   │   │   ├── security.md
│   │   │   ├── testing.md
│   │   │   └── ...
│   │   ├── python/            # Python 规范
│   │   ├── golang/            # Go 规范
│   │   └── typescript/        # TypeScript 规范
│   ├── hooks/                 # 自动化护栏
│   │   └── hooks.json         # 钩子配置
│   ├── mcp-configs/          # MCP 服务器配置
│   │   └── servers.json       # MCP 服务器列表
│   ├── templates/             # 配置模板
│   │   ├── project-claude.md  # 项目 CLAUDE.md 模板
│   │   └── settings.json     # Claude Code 设置模板
│   └── scripts/               # 一键设置脚本
│       ├── install.ps1        # Windows 安装脚本
│       └── install.sh         # Linux/Mac 安装脚本
├── .skills/                    # 【核心区】战术武器库 (Skills 2.0)
├── skills/                     # 【待处理区】备用/遗留技能
├── archive/                    # 【气闸区】隔离资产
├── global_rules.md             # 全局路由表
├── state/                      # 上下文锚点与状态
└── SETUP_GUIDE.md              # 本文档
```

---

## 🚀 快速开始

### 方式一：自动安装（推荐）

**Windows (PowerShell)**:
```powershell
cd d:\AICoding\ai-coding-standards
.\.claude\scripts\install.ps1
```

**Linux/Mac**:
```bash
cd /path/to/ai-coding-standards
chmod +x .claude/scripts/install.sh
./.claude/scripts/install.sh
```

### 方式二：手动建立符号链接

如果自动安装失败，可以手动建立符号链接：

**Windows (管理员权限)**:
```powershell
# agents
cmd /c mklink /D "$env:USERPROFILE\.claude\agents" "ai-coding-standards\.claude\agents"

# commands
cmd /c mklink /D "$env:USERPROFILE\.claude\commands" "ai-coding-standards\.claude\commands"

# rules
cmd /c mklink /D "$env:USERPROFILE\.claude\rules" "ai-coding-standards\.claude\rules"

# hooks
cmd /c mklink /D "$env:USERPROFILE\.claude\hooks" "ai-coding-standards\.claude\hooks"

# skills (指向核心区 .skills)
cmd /c mklink /D "$env:USERPROFILE\.claude\skills" "ai-coding-standards\.skills"

# .mcp.json
cmd /c mklink "$env:USERPROFILE\.claude\.mcp.json" "ai-coding-standards\.claude\mcp-configs\servers.json"
```

**Linux/Mac**:
```bash
# agents
ln -s ai-coding-standards/.claude/agents ~/.claude/agents

# commands
ln -s ai-coding-standards/.claude/commands ~/.claude/commands

# rules
ln -s ai-coding-standards/.claude/rules ~/.claude/rules

# hooks
ln -s ai-coding-standards/.claude/hooks ~/.claude/hooks

# skills (指向核心区 .skills)
ln -s ai-coding-standards/.skills ~/.claude/skills

# .mcp.json
ln -s ai-coding-standards/.claude/mcp-configs/servers.json ~/.claude/.mcp.json
```

---

## 🔧 配置映射关系

| Claude 路径 | 配置中心路径 | 类型 |
|------------|-------------|------|
| `~/.claude/agents` | `ai-coding-standards/.claude/agents` | 符号链接 |
| `~/.claude/commands` | `ai-coding-standards/.claude/commands` | 符号链接 |
| `~/.claude/rules` | `ai-coding-standards/.claude/rules` | 符号链接 |
| `~/.claude/hooks` | `ai-coding-standards/.claude/hooks` | 符号链接 |
| `~/.claude/.mcp.json` | `ai-coding-standards/.claude/mcp-configs/servers.json` | 符号链接 |
| `~/.claude/skills` | `ai-coding-standards/.skills` | 符号链接 |

---

## 📝 使用说明

### 标准工作流命令

配置完成后，可在 Claude Code 中使用以下命令：

```bash
/plan          # 规划任务 → 调用 planner agent
/tdd           # 测试驱动开发 → RED→GREEN→REFACTOR
/verify        # 验证实现 → 对比需求
/code-review   # 代码审查 → reviewer + security agent
/checkpoint    # 记录快照 → 保存思路
```

### 配置更新流程

1. 在 `ai-coding-standards` 中修改配置
2. 提交到 git 仓库
3. 在其他电脑上 `git pull` 更新
4. 运行安装脚本恢复符号链接

---

## 🔄 在其他电脑上恢复配置

### 步骤

1. **克隆仓库**
   ```bash
   git clone <your-repo-url> ai-coding-standards
   cd ai-coding-standards
   ```

2. **运行安装脚本**
   ```bash
   # Windows
   .\.claude\scripts\install.ps1

   # Linux/Mac
   chmod +x ./.claude/scripts/install.sh
   ./.claude/scripts/install.sh
   ```

3. **重启 Claude Code**

4. **验证配置**
   - 使用 `/plan` 测试
   - 使用 `/tdd` 测试工作流

---

## ⚠️ 注意事项

### Windows 用户
- 需要管理员权限创建符号链接
- 如果符号链接失败，脚本会自动回退到复制模式

### 路径问题
- 如果使用不同的克隆路径，需要修改 `install.sh` 脚本中的 `SCRIPT_DIR` 获取方式

### 备份
- 安装脚本会自动备份现有配置
- 备份位置：`~/.claude/*.backup.*`

---

## 📚 参考资源

- [everything-claude-code](https://github.com/affaan-m/everything-claude-code)
- [Claude Code 官方文档](https://docs.anthropic.com/claude-code)
- [全局规范](global_rules.md)

---

**维护者**: 逸风
**配置版本**: v9.0
