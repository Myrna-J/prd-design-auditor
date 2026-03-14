# 路由协议 (Routing Protocol)

> 本文件定义任务类型与对应处理规范的路由映射。

## 路由表

⚠️ **关键规则**：本文件是"路由表"。在执行具体任务前，**必须**根据任务类型加载对应详细规范。

| 任务类型 | 强制查阅文件 (Mandatory Read) | 核心目标 |
| :--- | :--- | :--- |
| **项目初始化** (Init) | [.claude/rules/common/init_project.md](../.claude/rules/common/init_project.md) | 确保目录结构标准统一 |
| **任务规划** (Plan) | 使用 `/plan` 命令 → 调用 planner agent | 结构化规划，评估风险，等待确认 |
| **代码开发/重构** (Coding) | [.claude/rules/common/style_guide.md](../.claude/rules/common/style_guide.md) | 统一代码风格、环境规范 |
| **测试驱动开发** (TDD) | 使用 `/tdd` 命令 → RED→GREEN→REFACTOR 循环 | 测试先行，80%+ 覆盖率 |
| **测试编写** (Testing) | [.claude/rules/common/testing_guide.md](../.claude/rules/common/testing_guide.md) | 测试覆盖率、测试组织 |
| **代码审查** (Review) | 使用 `/code-review` → reviewer + security agent | 自动化代码质量与安全审查 |
| **错误处理** (Error) | [.claude/rules/common/error_handling_guide.md](../.claude/rules/common/error_handling_guide.md) | 异常处理、日志规范 |
| **部署运维** (Deploy) | [.claude/rules/common/deployment_guide.md](../.claude/rules/common/deployment_guide.md) | CI/CD、监控、事故响应 |
| **使用特定技能** (Skill) | [.skills/README.md](../.skills/README.md) | 获取标准化的能力支持 |
| **复盘/进化** (Evolve) | [.skills/claudeception/SKILL.md](../.skills/claudeception/SKILL.md) | 执行知识沉淀与文档缝合 |
| **文档格式** (Format) | [docs/guides/DOCUMENT_UPDATE_FORMAT.md](../docs/guides/DOCUMENT_UPDATE_FORMAT.md) | 复盘文档更新格式规范 |
| **检查点记录** (Checkpoint) | 使用 `/checkpoint` 命令 | 保存思路快照，便于回溯 |
| **文档导航** (Query) | [INDEX.md](../INDEX.md) | 快速定位规范文件 |
| **术语规范** (Term) | [docs/TERMINOLOGY.md](../docs/TERMINOLOGY.md) | 统一术语用法 |
| **问题排查** (Debug) | [memory/anti_patterns.md](../memory/anti_patterns.md) | 按症状查找陷阱 |
| **规范诊断** (Health) | [docs/HEALTH_METRICS.md](../docs/HEALTH_METRICS.md) | 评估规范健康度 |

## 工作流命令

```bash
/plan          # 规划任务 → 调用 planner agent
/tdd           # 测试驱动开发 → RED→GREEN→REFACTOR
/verify        # 验证实现 → 对比需求
/code-review   # 代码审查 → reviewer + security agent
/checkpoint    # 记录快照 → 保存思路
/evolve        # 执行复盘
```

## 工作模式

1. **复杂任务**：Plan → Execute → Update Context → Review
2. **简单任务**：直接执行 (SafeToAutoRun)

## 物理环境执行边界与隔离 SOP

> ⚠️ **禁区声明**：“逻辑错误可以跨天重写，但环境污染必须彻底重装。”

所有参与本生态建设的 AI 智能体必须恪守以下物理执行隔离纪律：

1. **绝对禁区划定**：严禁 AI 自行尝试激活 `virtualenv`、执行 `pip install` 等变更底层依赖的操作，或调用 `PyInstaller` 进行物理机本地构建与打包方案实验。
2. **人类兜底机制 (指挥官保留权)**：上述包含物理环境变更（包管理、依赖树更新）与实际分发执行（打包构建）的操作，必须且**只能由人类指挥官在宿主机终端里手动执行**。AI 的操作受限于对代码源码文件（如 `src/*.py`）、项目状态文档和参数配置文件（如 `.spec`）的逻辑修改。

---

*版本*: v1.0
*更新*: 2026-03-01
*来源*: 从 `global_rules.md` 第二章拆分
