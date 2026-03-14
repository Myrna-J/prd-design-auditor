# PRD Design Auditor - 项目索引

> **项目路径**: `projects/prd-design-auditor/`
> **当前版本**: 2.0.0 (产品经理AI助理)
> **重构日期**: 2026-03-14

---

## 🚀 快速开始

### 进入项目
```bash
cd projects/prd-design-auditor
```

### 查看当前状态
```bash
# 系统状态锚点
cat state/context.md

# 待办事项
cat TODO.md

# 产品战略
cat .claude/product-strategy-context.md
```

---

## 📁 核心文件导航

| 文件 | 用途 |
|------|------|
| `README.md` | 项目主文档（已重构为产品经理AI助理） |
| `core/identity.md` | AI身份、用户称呼(Myrna)、语言规范 |
| `core/routing.md` | 任务路由表、工作流命令 |
| `core/architecture.md` | 架构与切割法则 |
| `state/context.md` | 当前系统状态 ⭐ |
| `TODO.md` | 任务清单 |

---

## 🛠️ 核心技能 (.skills/)

### 新增技能（2.0版本）

| 技能 | 功能 | 文档 |
|------|------|------|
| **01-requirement-analyst** | 需求分析师 - 将模糊需求转化为结构化用户故事 | [SKILL.md](.skills/01-requirement-analyst/SKILL.md) |
| **02-document-writer** | 文档撰写师 - 生成标准化PRD文档 | [SKILL.md](.skills/02-document-writer/SKILL.md) |
| **03-audit-expert** | 审计专家 - 审计PRD的逻辑漏洞和质量缺陷 | [SKILL.md](.skills/03-audit-expert/SKILL.md) |
| **04-report-generator** | 报告生成器 - 输出多格式正式报告 | [SKILL.md](.skills/04-report-generator/SKILL.md) |

### 原有技能

| 技能 | 功能 |
|------|------|
| `code-review` | 代码审查 |
| `verify` | 验证实现 |
| `tdd-workflow-updated` | TDD工作流 |
| `test-coverage` | 测试覆盖 |
| `e2e-testing` | E2E测试 |

---

## 📋 使用示例

### 完整工作流

```bash
# Step 1: 需求分析
# 输入: 业务方原始需求
# AI 执行 01-requirement-analyst
# 输出: docs/requirements/user-stories.md

# Step 2: 文档撰写
# 输入: 需求分析输出
# AI 执行 02-document-writer
# 输出: docs/prd/PRD-xxx-v1.md

# Step 3: 质量审计
# 输入: PRD文档
# AI 执行 03-audit-expert
# 输出: docs/audit/audit-report-xxx.md

# Step 4: 报告生成
# 输入: 审计结果
# AI 执行 04-report-generator
# 输出: docs/reports/RPT-xxx.pdf
```

---

## 🔄 重构历史

| 版本 | 日期 | 变更 |
|------|------|------|
| 1.0 | 2026-03-09 | 初始版本 - PRD & Design Auditor（不动产经营） |
| 2.0 | 2026-03-14 | 重构为产品经理AI助理，新增4个核心技能 |

---

## ⚠️ 重要约束

- **核心区保护**: 严禁自动修改 `core/` 目录
- **物理环境禁区**: AI不得执行 pip install、打包等操作
- **技能软链接**: 部分 `.skills/` 是软链接，指向配置中心

---

*最后更新: 2026-03-14*
