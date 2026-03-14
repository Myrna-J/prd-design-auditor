# 项目模板脚手架 (Project Scaffold)

> 本文档用于定义所有从配置中心繁衍出的新项目的基础契约和组织范式。

## 项目启动与开发契约

本项目的 AI 协作必须严格遵循[配置中心 (ai-coding-standards)](https://github.com/windripple82/ai-coding-standards) 延伸出的核心架构：

1. **三维切割法则**：所有产生的 SOP 代码规范或项目规约，必须按可移植性切割，将详细指令沉淀到独立 markdown，而不是在此文件堆砌。
2. **绝对物理隔离**：AI 可以编写源码（`src/`）与测试，修改部署配置（`.spec` / `.json`），但绝对禁止帮命令行代行 `pip install` 或者构建物理打包分发文件。
3. **先做再议**：执行任务时遵循评估并优先执行已达成共识目标的原则，有异议事后抛出。

## 目录组织
```text
your-project-name/
├── .claude/                # 配置中心子目录
│   ├── CLAUDE.md           # 局部命令中枢 (What 契约)
│   └── scripts/            # AI 执行或辅助脚本
│       └── hooks/          # Git hook 校验审计脚本
├── core/                   # 核心代码与架构模型
├── docs/                   # 外部接口文档或规范指引
│   └── logs/               # 会话复盘日志备份坑位
├── src/                    # 具体的开发源码
├── state/                  # 记录与状态机
│   ├── context.md          # 每次对话系统预加载的状态锚点
│   └── work-log.md         # 详细过程工作日志
└── tests/                  # 测试组件与 E2E 沙盒
```

## 测试与分发
- **测试生态**: 严格执行测试驱动开发 `/tdd` 流程图，所有模块编写后必须配好基本单测。
- **构建边界**: 对于诸如需打包子进程库的环境，必须参考 `skills/windows-subprocess-injection.md` 走沙盒级依赖注入。

## 审计与复盘 Hook

> **🚨 [CRITICAL] 物理审计激活**: 初始化项目后，**必须第一优先**运行环境装载脚本以激活物理防线与 Git 穿透审计！
> - Windows: `pwsh .claude/scripts/install.ps1` (需自行实现/对应) 或直接建立软链接。
> - 手动启用命令: `New-Item -ItemType SymbolicLink -Path .git/hooks/commit-msg -Target .claude/scripts/hooks/commit-msg-check.ps1`

本项目遵循"穿透式审计"法则 (commit-msg 校验)：
1. 提交代码时，Git 会触发 `.claude/scripts/hooks/commit-msg-check.ps1`
2. 将检查 `docs/logs/session-log-*.md` 最新复盘生成时间是否**晚于**上次 commit 时间。如果不满足，请先执行 `/evolve` 强制复盘。
3. 紧急情况下，可在提交信息内包含 `[skip-review]` 以绕过审计，但滥用会污染状态！

### 【进化审计与规则自生长】
本项目自带免疫与认知提取引擎 (`.skills/`)。在每一次遭遇错误、执行联调、或执行日常 `/evolve` 复盘时：
- AI 必须**自动激活**对防范漏洞模式的提取评估。
- 新的约束与坑应该存量结构化进入 `.skills/evolution-db.json`，形成永久化反模式(Anti-patterns)或规范文档(Skills)。
- 这是保证架构随项目一同进化的最关键步骤！
