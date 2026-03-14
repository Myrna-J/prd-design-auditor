# /e2e - 运行端到端测试

## 功能

运行项目的端到端（E2E）测试，支持多种测试类型和框架。

---

## 使用方式

```bash
/e2e
/e2e --type=browser
/e2e --type=api --flow=user-login
/e2e --env=staging
```

---

## 参数说明

| 参数 | 说明 | 可选值 | 默认值 |
|------|------|--------|--------|
| `--type` | 测试类型 | `browser`, `cli`, `api`, `all` | `all` |
| `--flow` | 指定测试流程 | 任何有效的流程名称 | 运行所有 |
| `--env` | 测试环境 | `dev`, `staging`, `prod` | `dev` |
| `--headed` | 显示浏览器窗口 | - | false（无头模式） |
| `--debug` | 调试模式 | - | false |

---

## 工作流程

### 1. 检测项目类型

自动识别项目使用的测试框架：

**Python 项目**:
- pytest + playwright
- pytest + pytest-playwright

**TypeScript/JavaScript 项目**:
- @playwright/test
- CodeceptJS

**Go 项目**:
- 无标准 E2E 框架，需手动配置

### 2. 执行测试

根据 `--type` 参数执行相应的测试：

#### Browser（浏览器自动化）
```bash
# Python
pytest tests/e2e/browser --browser chromium

# TypeScript
npx playwright test --project=chromium
```

#### CLI（命令行测试）
```bash
# 测试 CLI 工具的输入输出
pytest tests/e2e/cli -v
```

#### API（API 测试）
```bash
# 测试 REST API 端点
pytest tests/e2e/api -v
# 或
npx jest tests/e2e/api
```

### 3. 生成报告

自动生成测试报告：

- **HTML 报告**: `tests/e2e/reports/html/index.html`
- **Allure 报告**: `tests/e2e/reports/allure/`
- **JSON 结果**: `tests/e2e/reports/results.json`
- **截图**: `tests/e2e/screenshots/`（仅失败时）

### 4. 显示结果摘要

```
✅ 通过: 45
❌ 失败: 2
⏭️  跳过: 3
⏱️  耗时: 2m 34s

📊 覆盖率: 87.5%

📁 查看详细报告:
   HTML: tests/e2e/reports/html/index.html
   Allure: allure open tests/e2e/reports/allure
```

---

## 测试文件约定

### 目录结构

```
tests/
├── e2e/
│   ├── flows/              # YAML 测试用例（可选）
│   │   ├── user-login.yaml
│   │   └── checkout.yaml
│   ├── browser/            # 浏览器测试
│   │   ├── auth.spec.ts
│   │   └── checkout.spec.ts
│   ├── cli/                # CLI 测试
│   │   └── command.test.ts
│   ├── api/                # API 测试
│   │   └── users.test.ts
│   ├── fixtures/           # 测试数据
│   │   └── users.json
│   └── reports/            # 测试报告
```

### YAML 测试用例格式（可选）

```yaml
# tests/e2e/flows/user-login.yaml
flow: 用户登录流程
description: 验证用户能成功登录系统

tags: [auth, critical]

environment:
  baseUrl: "{{BASE_URL}}"
  users:
    valid:
      username: "test@example.com"
      password: "Password123!"

setup:
  - action: clearStorage
  - action: setViewport
    width: 1280
    height: 720

steps:
  - name: 访问登录页面
    action: navigate
    url: "/login"
    validate:
      - selector: "[data-testid='login-title']"
        text: "欢迎登录"
        exists: true

  - name: 输入凭据
    action: fill
    selector: "[data-testid='username-input']"
    value: "{{users.valid.username}}"

  - name: 输入密码
    action: fill
    selector: "[data-testid='password-input']"
    value: "{{users.valid.password}}"

  - name: 提交登录
    action: click
    selector: "[data-testid='login-submit']"
    validate:
      - selector: "[data-testid='user-avatar']"
        exists: true
      - url: "/dashboard"

teardown:
  - action: logout
  - action: clearCookies
```

---

## 定位器策略

优先级从高到低：

1. **data-testid**（最稳定）:
   ```typescript
   page.getByTestId('submit-button').click()
   ```

2. **Role + 文本**:
   ```typescript
   page.getByRole('button', { name: '提交' }).click()
   ```

3. **ARIA 标签**:
   ```typescript
   page.getByLabel('用户名').fill('test@example.com')
   ```

4. ❌ **避免**: CSS 选择器链、XPath（脆弱且易变）

---

## 失败重试

默认配置：
- 本地开发: 不重试
- CI 环境: 失败后重试 2 次

可在配置文件中调整：

```typescript
// playwright.config.ts
retries: process.env.CI ? 2 : 0
```

---

## 调试技巧

### 1. 使用 --headed 参数
```bash
/e2e --headed
```
显示浏览器窗口，观察测试执行过程。

### 2. 使用 --debug 参数
```bash
/e2e --debug
```
逐步执行测试，支持断点调试。

### 3. 查看详细日志
```bash
# 设置环境变量
DEBUG=pw:api /e2e
```

### 4. 查看截图和 Trace
```bash
# 打开 Playwright Trace
npx playwright show-trace tests/e2e/trace/trace.zip
```

---

## 常见问题

### Q: 测试超时怎么办？
A: 在配置文件中增加超时时间：
```typescript
// playwright.config.ts
timeout: 60000  // 60 秒
```

### Q: 如何测试需要登录的页面？
A: 使用 `storageState` 保存登录状态：
```typescript
// 保存登录状态
await page.context().storageState({ path: 'auth.json' })

// 加载登录状态
test.use({ storageState: 'auth.json' })
```

### Q: 如何并行执行测试？
A: Playwright 默认并行执行，可以配置 worker 数量：
```typescript
// playwright.config.ts
workers: process.env.CI ? 4 : undefined
```

---

## 参考资源

- **Playwright 文档**: https://playwright.dev
- **YAML Playwright**: `config/testing-ecosystem/playwright/yaml-adapter.config.ts`
- **测试规范**: `.claude/rules/common/e2e-testing.md`
- **快速入门**: `docs/guides/testing/e2e-quickstart.md`

---

*命令版本: 1.0.0*
*更新日期: 2026-03-05*
