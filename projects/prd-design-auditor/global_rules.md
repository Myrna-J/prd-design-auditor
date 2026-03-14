# 中文原生协议 v10.0 (Configuration Center)

> **重构说明**: 本文件已拆分为多个独立协议文档，便于维护和引用。

## 核心协议文档

| 协议 | 文件 | 描述 |
|-----|------|------|
| **核心身份** | [core/identity.md](core/identity.md) | 用户称呼、AI身份、语言规范 |
| **会话协议** | [core/session-protocol.md](core/session-protocol.md) | 开场白、复盘流程 |
| **路由协议** | [core/routing.md](core/routing.md) | 任务类型映射、工作流命令 |
| **架构与切割** | [core/architecture.md](core/architecture.md) | 三维切割法则、规则边界约束 |
| **协作权限** | [core/collaboration-discipline.md](core/collaboration-discipline.md) | 人机边界、放权闭环与红线原则 |

---

## 快速参考

### 开场白
```
Myrna，你好：
```

### 核心规则
- **中文优先**: 所有思考过程、解释说明、Git Message 使用简体中文
- **术语保留**: 技术术语 (API, JWT) 与代码标识符保持英文

### 上下文锚定
新会话启动时，自动阅读：
1. [state/context.md](state/context.md) (核心状态锚点 ⭐)
2. [README.md](README.md) (项目概览)

### 工作流命令
```bash
/plan          # 规划任务
/tdd           # 测试驱动开发
/verify        # 验证实现
/code-review   # 代码审查
/checkpoint    # 记录快照
/evolve        # 执行复盘
/harvest       # [CONFIG_CENTER] 从受控项目收割 [global] 技能并同步至脚手架
```

---

## 配置中心

**位置**: `ai-coding-standards/.claude/`

**一键设置**:
```powershell
# Windows
\.claude\scripts\install.ps1

# Linux/Mac
\.claude\scripts/install.sh
```

详见: [SETUP_GUIDE.md](SETUP_GUIDE.md)

---

## 通用行为铁律

### 环境安全 (Windows)
- **读取**: 必须使用 `Get-Content -Encoding UTF8`，严禁 `type`
- **写入**: 使用 `Set-Content -Encoding UTF8`
- **追加策略** (Tail-Anchor): 先读取末尾 10-20 行获取精确锚点，再精确替换
- **路径规范**:
  - 基准点：项目根目录（包含 .git）
  - 项目内：使用相对路径
  - 跨项目：通过环境变量或符号链接
  - **禁止**: 绝对路径、上级引用、用户路径
  - **[CRITICAL]核心区保护**: 严禁由 Python 或其他脚本自动化修改 `core/` 目录下的协议文件。任何逻辑变更必须由 Human Commander 确认。
  - **[CRITICAL]阻止暗影仓库**: 严禁在项目子目录下执行 `git init` 或创建独立的 `.git` 目录（防止绕过全局审计钩子）。所有变更必须在主仓库上下文内管理。
  - **[CRITICAL]运行路径隔离 (Runtime Path Isolation)**:
    - 严禁静默回退：任何脚本在操作 `.skills/` 前必须进行物理存在性检查（`assert os.path.exists`），如果缺失必须立刻抛出 Fatal Error 熔断，严禁降权回退至 legacy `skills/`。
    - 软链接去重：在处理 `.skills/` 软链接时，Agent 必须显式跳过对物理源路径的索引扫描，仅以 `.skills/` 逻辑路径为准，防止 100% 上下文冗余。
    - 环境普查：系统检索路径（`PATH`, `sys.path`）中，`.skills/` 对应的物理路径必须拥有绝对最高优先级。

### 工作模式
- **复杂任务**: Plan → Execute → Update Context → Review
- **简单任务**: 直接执行
- **自适应进化**: 出现报错、发现特殊约定或任务终结时，需强制遵循 `Claudeception` (.skills/claudeception) 约定自动抽取结构化经验。

### 6. 技能瘦身原则 (Skill Pruning)
Regularly review `.skills/evolution-db.json` and `.skills`. Merge redundant constraints into existing skills to avoid context bloat. You should perform this cleanup bi-weekly or when explicitly requested.

## 7. Global Promotion (Knowledge Syndication)
If the knowledge extracted is universally applicable (e.g., a common Windows path issue, a general Python library fix, or a recurring Red Team attack pattern), you **MUST** flag it for the "Mother Ship" (Config Center) to harvest:
- In `evolution-db.json`, add `[global]` to the `trigger` field.
- **REQUIRED PROTOCOL**: Use the `superpowers:skill-creator` (v2.0) guidelines to ensure the skill is structured for Structured Evaluation (Evals) and Benchmarking.
- This will signal the `scripts/harvest.ps1` tool in the `ai-coding-standards` repository to pull this skill into the global standards and project scaffold.

### 人机协作纪律 (Collaboration Discipline)
详见: [core/collaboration-discipline.md](core/collaboration-discipline.md)
- **先做再议 (具体放权区)**: 对于指挥官所有输入都要进行分类评估。常规任务直接闭环不反问；存异议的内容**待达成共识后执行**。
- **环境隔离 (红线确认区)**: 所有影响物理环境的行为（例如打包、发版、修改底层依赖、全局设置等）都收敛到人类指挥官手中。

---

## 安全与底线

- **依赖管理**: 严禁全局安装 Pip 包
- **密钥管理**:
  - 严禁硬编码 API Key、密码、Token
  - 必须通过环境变量或 `.env` 文件加载
  - `.env` 必须加入 `.gitignore`
  - 必须提供 `.env.example`
- **状态维护**: 任务结束时必须执行复盘协议
- **[CRITICAL] 安全气闸 (Airlock) 协议**: 所有标记为过时 (Deprecated) 的物理资产必须移入 `archive/` 目录。严禁读取该目录下的逻辑作为当前任务的依据，以防产生“逻辑幻觉”或环境配置冲突。

---

*版本*: v10.0 (重构版)
*更新*: 2026-03-01
*变更*: 拆分为 core/ 目录下的独立协议文档
