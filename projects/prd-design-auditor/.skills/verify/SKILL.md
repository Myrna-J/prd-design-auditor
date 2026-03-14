# /verify - 全管道代码验证

## 功能

执行完整的代码质量检查管道：**测试 + Lint + 安全扫描 + 类型检查**

---

## 使用方式

```bash
/verify
/verify --skip-security
/verify --fix
```

---

## 参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--skip-tests` | 跳过测试 | false |
| `--skip-lint` | 跳过 Lint 检查 | false |
| `--skip-security` | 跳过安全扫描 | false |
| `--skip-types` | 跳过类型检查 | false |
| `--fix` | 自动修复问题 | false |

---

## 验证流程

### 1. 测试验证

运行所有测试并检查覆盖率：

```bash
# Python
pytest --cov=src --cov-fail-under=80

# TypeScript/JavaScript
npm test
npm run test:coverage

# Go
go test -race -coverprofile=coverage.out ./...
go tool cover -func=coverage.out
```

**要求**:
- 所有测试必须通过
- 覆盖率 ≥ 80%

**输出**:
```
✅ 测试通过: 145/145
📊 覆盖率: 87.3%
```

---

### 2. 代码格式检查

检查代码格式是否符合规范：

```bash
# Python - Black
black --check src/ tests/

# TypeScript/JavaScript - Prettier
prettier --check "src/**/*.{ts,tsx,js,jsx}"

# Go - gofmt
gofmt -l .
```

**自动修复**（使用 `--fix` 参数）:
```bash
black src/ tests/
prettier --write "src/**/*.{ts,tsx,js,jsx}"
gofmt -w .
```

**输出**:
```
✅ 代码格式检查通过
```

---

### 3. Lint 检查

检查代码质量问题：

```bash
# Python - Ruff
ruff check src/ tests/

# TypeScript/JavaScript - ESLint
eslint "src/**/*.{ts,tsx,js,jsx}"

# Go - golangci-lint
golangci-lint run
```

**自动修复**（使用 `--fix` 参数）:
```bash
ruff check --fix src/ tests/
eslint --fix "src/**/*.{ts,tsx,js,jsx}"
```

**输出**:
```
✅ Lint 检查通过
⚠️  警告: 3 个（未使用的变量）
```

---

### 4. 类型检查

检查类型安全：

```bash
# Python - mypy
mypy src/

# TypeScript/JavaScript - tsc
tsc --noEmit

# Go - 内置
go build ./...
```

**输出**:
```
✅ 类型检查通过
```

---

### 5. 安全扫描

检查安全问题：

```bash
# Python - bandit
bandit -r src/

# TypeScript/JavaScript - npm audit
npm audit --production

# Go - gosec
gosec ./...
```

**输出**:
```
✅ 安全扫描通过
⚠️  发现 2 个低风险问题（建议修复）
```

---

## 完整输出示例

```bash
/verify
```

```
🔍 开始全管道验证...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 100%

📋 验证结果摘要:

  ✅ 测试验证        145/145 通过   覆盖率 87.3%
  ✅ 代码格式检查     所有文件符合规范
  ✅ Lint 检查       0 个错误, 3 个警告
  ✅ 类型检查        无类型错误
  ✅ 安全扫描        0 个高危问题

⚠️  警告 (3 个):
  - src/auth.py:45: 未使用的变量 `session_id`
  - src/utils.py:78: 行过长 (120 > 100)
  - src/api.py:102: 缺少错误处理

💡 建议:
  1. 移除未使用的变量
  2. 拆分长行
  3. 添加 API 错误处理

✅ 验证通过！代码可以提交。
```

---

## 失败情况示例

```bash
/verify
```

```
🔍 开始全管道验证...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 100%

❌ 验证失败！发现以下问题:

  ❌ 测试验证        3 个测试失败
     - test_user_login (AssertionError)
     - test_api_timeout (TimeoutError)
     - test_data_validation (ValueError)

  ⚠️  覆盖率         72.5% (要求 ≥ 80%)

  ❌ Lint 检查       5 个错误
     - src/auth.py:50: 未定义的变量 `token`
     - src/api.py:78: 语法错误

  ❌ 安全扫描        1 个中危问题
     - 使用了不安全的随机数生成器

🔧 请修复以上问题后再次运行 /verify
```

---

## 自动修复模式

使用 `--fix` 参数自动修复可修复的问题：

```bash
/verify --fix
```

**自动修复的内容**:
- 代码格式问题（Black, Prettier, gofmt）
- 部分 Lint 问题（未使用的导入、简单语法问题）
- 部分 TypeScript 类型问题

**不自动修复的内容**:
- 测试失败
- 安全问题
- 复杂的类型错误
- 业务逻辑错误

---

## 项目配置

### Python 项目 (pyproject.toml)

```toml
[tool.black]
line-length = 100
target-version = ['py311']

[tool.ruff]
line-length = 100
select = ["E", "F", "I", "B", "C4"]
ignore = ["E501"]

[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true

[tool.pytest.ini_options]
addopts = "--cov=src --cov-fail-under=80"
```

### TypeScript 项目 (package.json)

```json
{
  "scripts": {
    "test": "vitest",
    "test:coverage": "vitest --coverage",
    "lint": "eslint .",
    "lint:fix": "eslint --fix .",
    "format": "prettier --check .",
    "format:fix": "prettier --write .",
    "type-check": "tsc --noEmit",
    "verify": "npm-run-all test lint type-check"
  },
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ]
  }
}
```

### Go 项目 (.golangci.yml)

```yaml
linters:
  enable:
    - gofmt
    - govet
    - staticcheck
    - unused
    - gosimple

linters-settings:
  lll:
    line-length: 100
```

---

## CI/CD 集成

在 CI/CD 流水线中自动运行验证：

```yaml
# .github/workflows/verify.yml
name: Code Verification

on: [push, pull_request]

jobs:
  verify:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Python/Node/Go
        # ...

      - name: Run verification
        run: |
          # Python
          pytest --cov=src --cov-fail-under=80
          black --check src/ tests/
          ruff check src/
          mypy src/
          bandit -r src/

          # TypeScript
          npm test
          npm run lint
          npm run type-check
          npm audit --production
```

---

## 常见问题

### Q: 如何临时跳过某项检查？

A: 使用对应的 `--skip-*` 参数：
```bash
/verify --skip-security --skip-types
```

### Q: Lint 检查太严格怎么办？

A: 在配置文件中调整规则：
```toml
# pyproject.toml
[tool.ruff]
ignore = ["E501", "B008"]  # 忽略特定规则
```

### Q: 如何处理覆盖率不足？

A:
1. 运行覆盖率报告查看未覆盖的代码：
   ```bash
   pytest --cov=src --cov-report=html
   ```
2. 为未覆盖的功能添加测试
3. 如果是配置文件，可以在配置中排除：
   ```toml
   [tool.coverage.report]
   exclude_lines = ["if __name__ == .__main__.:"]
   ```

### Q: 安全扫描误报怎么办？

A: 在代码中添加注释忽略：
```python
# nosec  # 禁用 bandit 检查
random_token = os.random(16)
```

或在配置中排除特定规则：
```bash
bandit -r src/ --skip B311
```

---

## 参考资源

- **测试规范**: `.claude/rules/common/testing.md`
- **编码规范**: `.claude/rules/common/coding-style.md`
- **安全规范**: `.claude/rules/common/security.md`
- **语言特定规范**: `.claude/rules/{python,typescript,golang}/`

---

*命令版本: 1.0.0*
*更新日期: 2026-03-05*
