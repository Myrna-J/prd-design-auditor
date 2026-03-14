# /test-coverage - 测试覆盖率检查与报告

## 功能

检查和报告代码测试覆盖率，识别未覆盖的代码区域，提供改进建议。

---

## 使用方式

```bash
/test-coverage
/test-coverage --html
/test-coverage --min=90
```

---

## 参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--min` | 最低覆盖率要求 | 80 |
| `--html` | 生成 HTML 报告 | false |
| `--json` | 输出 JSON 格式 | false |
| `--fail-under` | 覆盖率低于此值时返回错误 | 80 |

---

## 覆盖率类型

### 1. 行覆盖率 (Line Coverage)

最基础的覆盖率指标，统计被执行的代码行占总代码行的比例。

```
行覆盖率: 87.3% (450/515 行)
```

**要求**: ≥ 80%

### 2. 分支覆盖率 (Branch Coverage)

统计代码中所有条件分支是否都被测试到。

```
分支覆盖率: 82.1% (64/78 分支)
```

**要求**: ≥ 75%

### 3. 函数覆盖率 (Function Coverage)

统计被调用的函数占总函数的比例。

```
函数覆盖率: 95.5% (85/89 函数)
```

**要求**: ≥ 90%

---

## 输出示例

### 基本输出

```bash
/test-coverage
```

```
📊 测试覆盖率报告

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

总体覆盖率: 87.3% ✅ (要求: ≥ 80%)

┌─────────────────┬──────────┬─────────┬────────┐
│ 模块            │ 行覆盖   │ 分支覆盖│ 函数覆盖│
├─────────────────┼──────────┼─────────┼────────┤
│ src/auth.py     │ 95.2% ✅ │ 88.9%   │ 100%   │
│ src/api.py      │ 91.7% ✅ │ 85.7%   │ 93.8%  │
│ src/utils.py    │ 78.3% ⚠️ │ 70.0%   │ 85.7%  │
│ src/config.py   │ 65.4% ❌ │ 50.0%   │ 75.0%  │
└─────────────────┴──────────┴─────────┴────────┘

⚠️  需要改进的模块:
  - src/config.py (65.4%) - 覆盖率不足 70%
  - src/utils.py (78.3%) - 覆盖率接近下限

💡 建议:
  1. 为 src/config.py 添加配置加载测试
  2. 为 src/utils.py 添加边界条件测试
  3. 考虑为 src/config.py 的错误处理添加测试

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

查看详细报告:
  HTML: htmlcov/index.html
  JSON: coverage.json
```

### HTML 报告

```bash
/test-coverage --html
```

生成可交互的 HTML 报告，在浏览器中查看：

```
✅ HTML 报告已生成: htmlcov/index.html

🌐 打开报告:
  - macOS: open htmlcov/index.html
  - Linux: xdg-open htmlcov/index.html
  - Windows: start htmlcov/index.html
```

HTML 报告特性：
- 📂 目录导航
- 📄 文件级覆盖率详情
- 🔢 逐行覆盖标记
  - 绿色: 已覆盖
  - 红色: 未覆盖
  - 黄色: 部分覆盖

---

## 未覆盖代码分析

### 查看未覆盖的代码行

```bash
/test-coverage --show-missing
```

```
未覆盖的代码行:

src/config.py:
  45: def load_config(path: str) -> dict:
  46:     """加载配置文件"""
  47:     if not os.path.exists(path):           ❌ 未覆盖
  48:         raise FileNotFoundError(path)      ❌ 未覆盖
  49:     with open(path) as f:                  ✅ 已覆盖
  50:         return json.load(f)                ✅ 已覆盖

src/utils.py:
  78: def format_date(date: datetime) -> str:   ✅ 已覆盖
  79:     if date is None:                       ❌ 未覆盖
  80:         return ""                          ❌ 未覆盖
  81:     return date.strftime("%Y-%m-%d")       ✅ 已覆盖
```

---

## 项目配置

### Python 项目

**安装依赖**:
```bash
pip install pytest pytest-cov
```

**配置 (pyproject.toml)**:
```toml
[tool.pytest.ini_options]
addopts = """
    --cov=src
    --cov-report=term-missing
    --cov-report=html
    --cov-fail-under=80
"""

[tool.coverage.run]
source = ["src"]
omit = [
    "*/tests/*",
    "*/test_*.py",
    "*/__init__.py",
]

[tool.coverage.report]
precision = 1
show_missing = true
skip_covered = false
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
    "if __name__ == .__main__.:",
    "if TYPE_CHECKING:",
    "@abstractmethod",
]
```

### TypeScript/JavaScript 项目

**安装依赖**:
```bash
npm install --save-dev vitest @vitest/coverage-v8
```

**配置 (vitest.config.ts)**:
```typescript
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'json'],
      lines: 80,
      functions: 90,
      branches: 75,
      statements: 80,
      exclude: [
        'node_modules/',
        'tests/',
        '**/*.test.ts',
        '**/*.config.ts',
      ],
    },
  },
})
```

**运行覆盖率**:
```bash
npm run test:coverage
```

### Go 项目

**运行覆盖率**:
```bash
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

**配置**（.golangci.yml）:
```yaml
coverage:
  enabled: true
  full: true  # 要求 100% 覆盖率
```

---

## 覆盖率阈值

### 根据代码类型设置不同要求

| 代码类型 | 最低覆盖率 | 说明 |
|---------|-----------|------|
| 核心业务逻辑 | ≥ 90% | 高风险代码，需要充分测试 |
| 工具函数 | ≥ 80% | 中等风险代码 |
| 配置文件 | ≥ 60% | 低风险，主要是声明 |
| 数据模型 | ≥ 70% | 验证逻辑需要测试 |

### 设置分级阈值

**Python (pyproject.toml)**:
```toml
[tool.coverage.report]
fail_under = 80  # 总体要求

[tool.coverage.report.branch_coverage]
# 不同模块的不同要求
"src/auth/*" = 90
"src/utils/*" = 80
"src/config/*" = 60
```

---

## 提高覆盖率的策略

### 1. 识别未覆盖的代码

```bash
# 查看未覆盖的代码行
/test-coverage --show-missing

# 生成 HTML 报告查看详情
/test-coverage --html
```

### 2. 分析未覆盖的原因

未覆盖的代码通常属于以下几类：

| 类型 | 示例 | 测试策略 |
|------|------|---------|
| 错误处理 | `if not os.path.exists(path)` | 故意触发错误条件 |
| 边界条件 | `if index < 0 or index >= len` | 测试边界值 |
| 异常分支 | `except ValueError as e:` | 模拟异常情况 |
| 未使用代码 | 死代码 | 删除或标记 |

### 3. 添加缺失的测试

#### 示例：测试错误处理

```python
# src/config.py
def load_config(path: str) -> dict:
    if not os.path.exists(path):
        raise FileNotFoundError(path)
    with open(path) as f:
        return json.load(f)

# tests/test_config.py
def test_load_config_with_nonexistent_file():
    """测试加载不存在的配置文件"""
    with pytest.raises(FileNotFoundError):
        load_config("/nonexistent/config.json")

def test_load_config_with_valid_file(tmp_path):
    """测试加载有效的配置文件"""
    config_file = tmp_path / "config.json"
    config_file.write_text('{"key": "value"}')

    config = load_config(str(config_file))
    assert config == {"key": "value"}
```

#### 示例：测试边界条件

```python
# src/utils.py
def get_item(items: list, index: int) -> Any:
    if index < 0 or index >= len(items):
        raise IndexError("Index out of range")
    return items[index]

# tests/test_utils.py
def test_get_item_with_valid_index():
    """测试有效索引"""
    items = ["a", "b", "c"]
    assert get_item(items, 0) == "a"
    assert get_item(items, 2) == "c"

def test_get_item_with_negative_index():
    """测试负索引（边界条件）"""
    items = ["a", "b", "c"]
    with pytest.raises(IndexError):
        get_item(items, -1)

def test_get_item_with_out_of_range_index():
    """测试超出范围的索引（边界条件）"""
    items = ["a", "b", "c"]
    with pytest.raises(IndexError):
        get_item(items, 10)
```

### 4. 使用参数化测试

```python
import pytest

@pytest.mark.parametrize("index,expected", [
    (0, "a"),
    (1, "b"),
    (2, "c"),
])
def test_get_item_with_valid_indices(index, expected):
    """参数化测试多个有效索引"""
    items = ["a", "b", "c"]
    assert get_item(items, index) == expected
```

---

## 排除代码

某些代码不需要测试覆盖，可以在配置中排除：

### Python

```toml
[tool.coverage.run]
omit = [
    "*/tests/*",
    "*/test_*.py",
    "*/__init__.py",
    "*/migrations/*",  # Django 迁移文件
]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",          # 显式标记
    "def __repr__",              # 表示方法
    "raise AssertionError",       # 断言
    "raise NotImplementedError",  # 未实现
    "if __name__ == .__main__.:",  # 主程序入口
    "if TYPE_CHECKING:",         # 类型检查
    "@abstractmethod",            # 抽象方法
    "class .*Protocol.*:",       # Protocol 类
]
```

### TypeScript

```typescript
// vitest.config.ts
export default defineConfig({
  test: {
    coverage: {
      exclude: [
        'node_modules/',
        'tests/',
        '**/*.test.ts',
        '**/*.config.ts',
        '**/*.d.ts',           // 类型声明文件
        '**/dist/**',          // 构建输出
      ],
    },
  },
})
```

---

## CI/CD 集成

### 在 CI 中强制覆盖率检查

```yaml
# .github/workflows/coverage.yml
name: Coverage Check

on: [push, pull_request]

jobs:
  coverage:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install pytest pytest-cov

      - name: Run tests with coverage
        run: |
          pytest --cov=src --cov-fail-under=80

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage.xml
```

### 覆盖率徽章

在 README.md 中添加覆盖率徽章：

```markdown
[![Coverage](https://codecov.io/gh/yourusername/yourrepo/branch/main/graph/badge.svg)](https://codecov.io/gh/yourusername/yourrepo)
```

---

## 常见问题

### Q: 覆盖率高但测试质量差怎么办？

A: 覆盖率只是量化指标，不是质量保证。需要：
1. 审查测试用例是否测试了正确的行为
2. 使用代码审查确保测试质量
3. 关注分支覆盖率而非行覆盖率
4. 使用变异测试（mutation testing）评估测试质量

### Q: 如何测试私有方法？

A:
1. **通过公共接口测试**：推荐方式，测试使用私有方法的公共功能
2. **使用测试友好的访问控制**：
   - Python: 使用单个下划线（`_method`）而非双下划线
   - TypeScript: 使用 `/* @internal */` 注释
3. **避免测试实现细节**：测试行为而非实现

### Q: 100% 覆盖率值得追求吗？

A: 通常**不值得**。原因：
1. 边际收益递减：最后 5% 可能需要 50% 的测试工作
2. 可能导致脆弱的测试
3. 某些代码（如配置）不需要高覆盖率

**建议目标**：
- 核心业务逻辑: 90-95%
- 工具函数: 80-90%
- 总体: 80-85%

---

## 参考资源

- **测试规范**: `.claude/rules/common/testing.md`
- **TDD 指南**: `/tdd` 命令
- **代码验证**: `/verify` 命令
- **Python Coverage**: https://coverage.readthedocs.io/
- **Vitest Coverage**: https://vitest.dev/guide/coverage.html

---

*命令版本: 1.0.0*
*更新日期: 2026-03-05*
